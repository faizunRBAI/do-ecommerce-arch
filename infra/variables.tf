variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "spaces_access_key" {
  description = "DigitalOcean Spaces access key ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "spaces_secret_key" {
  description = "DigitalOcean Spaces secret access key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "project_name" {
  description = "Project name used as a resource prefix (lowercase, hyphens only)"
  type        = string
}

variable "region" {
  description = "DigitalOcean region slug for Droplets, LB, Spaces, and database clusters"
  type        = string
  default     = "nyc3"
}

variable "droplet_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "db_password" {
  description = "Managed PostgreSQL application user password (alphanumeric, no special chars)"
  type        = string
  sensitive   = true
}

variable "django_secret_key" {
  description = "Django SECRET_KEY"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key injected by the platform at deploy time"
  type        = string
  default     = ""
}
