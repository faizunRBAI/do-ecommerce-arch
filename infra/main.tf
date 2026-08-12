# ─── SSH Key (platform-managed, looked up by name) ───────────────────────────
data "digitalocean_ssh_key" "main" {
  name = "udap-${var.project_name}"
}

# ─── VPC ──────────────────────────────────────────────────────────────────────
resource "digitalocean_vpc" "main" {
  name     = "${var.project_name}-vpc"
  region   = var.region
  ip_range = "10.10.0.0/16"
}

# ─── Cloud Firewall ───────────────────────────────────────────────────────────
resource "digitalocean_firewall" "web" {
  name = "${var.project_name}-firewall"

  droplet_ids = [digitalocean_droplet.web.id]

  # Allow HTTP + HTTPS from anywhere (LB forwards here)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # SSH from GitHub Actions runner IPs (open; tighten with IP allowlist in Tier 3)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow all outbound
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# ─── Droplet (app server) ─────────────────────────────────────────────────────
resource "digitalocean_droplet" "web" {
  name     = "${var.project_name}-web"
  region   = var.region
  size     = var.droplet_size
  image    = "ubuntu-22-04-x64"
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [data.digitalocean_ssh_key.main.fingerprint]

  tags = ["${var.project_name}", "web", "udap"]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3.11 python3.11-venv python3-pip nginx git curl
  EOF
}

# ─── DO Load Balancer ─────────────────────────────────────────────────────────
resource "digitalocean_loadbalancer" "web" {
  name   = "${var.project_name}-lb"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"
    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    protocol               = "http"
    port                   = 80
    path                   = "/health/"
    check_interval_seconds = 15
    response_timeout_seconds = 5
    unhealthy_threshold    = 3
    healthy_threshold      = 2
  }

  droplet_ids = [digitalocean_droplet.web.id]
  vpc_uuid    = digitalocean_vpc.main.id
}

# ─── Managed PostgreSQL ───────────────────────────────────────────────────────
resource "digitalocean_database_cluster" "postgres" {
  name       = "${var.project_name}-pg"
  engine     = "pg"
  version    = "16"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1

  tags = ["${var.project_name}", "database", "udap"]
}

resource "digitalocean_database_db" "app" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "ecommerce"
}

resource "digitalocean_database_user" "app" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "ecomm_user"
}

# Restrict DB access to the VPC only
resource "digitalocean_database_firewall" "postgres" {
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.web.id
  }
}

# ─── Managed Redis ────────────────────────────────────────────────────────────
resource "digitalocean_database_cluster" "redis" {
  name       = "${var.project_name}-redis"
  engine     = "redis"
  version    = "7"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1

  tags = ["${var.project_name}", "redis", "udap"]
}

resource "digitalocean_database_firewall" "redis" {
  cluster_id = digitalocean_database_cluster.redis.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.web.id
  }
}

# ─── DO Spaces (S3-compatible object storage + CDN) ───────────────────────────
resource "random_id" "spaces_suffix" {
  byte_length = 4
  keepers = {
    project = var.project_name
  }
}

resource "digitalocean_spaces_bucket" "media" {
  name   = "${var.project_name}-media-${random_id.spaces_suffix.hex}"
  region = var.region
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }
}

resource "digitalocean_cdn" "media" {
  origin = digitalocean_spaces_bucket.media.bucket_domain_name
  ttl    = 3600
}

# ─── DO Project (groups all resources) ───────────────────────────────────────
resource "digitalocean_project" "main" {
  name        = var.project_name
  description = "E-commerce platform — managed by UDAP"
  purpose     = "Web Application"
  environment = "Production"

  resources = [
    digitalocean_droplet.web.urn,
    digitalocean_loadbalancer.web.urn,
    digitalocean_database_cluster.postgres.urn,
    digitalocean_database_cluster.redis.urn,
    digitalocean_spaces_bucket.media.urn,
  ]
}
