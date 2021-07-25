variable "subnet_id" {
  description = "Subnet"
}

variable "public_key_path" {
  description = "Public key path"
}

variable "private_key_path" {
  description = "Private key path"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_internal_ip {
  description = "Internal DATABASE IP"
  default     = "127.0.0.1"
}

variable env {
  description = "Environment name"
  default     = "dev"
}
