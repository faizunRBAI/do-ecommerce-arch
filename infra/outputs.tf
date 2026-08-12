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
  description = "Full PostgreSQL connection URI (private network)"
  value       = digitalocean_database_cluster.postgres.private_uri
  sensitive   = true
}
