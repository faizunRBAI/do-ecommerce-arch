output "droplet_ip" {
  description = "Public IP of the web Droplet"
  value       = digitalocean_droplet.web.ipv4_address
}

output "load_balancer_ip" {
  description = "Public IP of the DO Load Balancer"
  value       = digitalocean_loadbalancer.web.ip
}

output "db_host" {
  description = "Managed PostgreSQL private hostname"
  value       = digitalocean_database_cluster.postgres.private_host
}

output "db_port" {
  description = "Managed PostgreSQL port"
  value       = digitalocean_database_cluster.postgres.port
}

output "db_name" {
  description = "Application database name"
  value       = digitalocean_database_db.app.name
}

output "db_user" {
  description = "Application database user"
  value       = digitalocean_database_user.app.name
}

output "db_uri" {
  description = "Full PostgreSQL connection URI (uses master user)"
  value       = digitalocean_database_cluster.postgres.private_uri
  sensitive   = true
}

output "redis_host" {
  description = "Managed Redis private hostname"
  value       = digitalocean_database_cluster.redis.private_host
}

output "redis_port" {
  description = "Managed Redis port"
  value       = digitalocean_database_cluster.redis.port
}

output "redis_password" {
  description = "Managed Redis authentication password"
  value       = digitalocean_database_cluster.redis.password
  sensitive   = true
}

output "spaces_bucket_name" {
  description = "DO Spaces bucket name for media files"
  value       = digitalocean_spaces_bucket.media.name
}

output "spaces_region" {
  description = "DO Spaces region"
  value       = digitalocean_spaces_bucket.media.region
}

output "spaces_cdn_endpoint" {
  description = "DO Spaces CDN endpoint URL"
  value       = digitalocean_cdn.media.endpoint
}
