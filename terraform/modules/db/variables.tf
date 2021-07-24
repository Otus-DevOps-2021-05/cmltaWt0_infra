variable "subnet_id" {
  description = "Subnet"
}

variable "public_key_path" {
  description = "Public key path"
}

variable "private_key_path" {
  description = "Private key path"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable env {
  description = "Environment name"
  default     = "dev"
}
