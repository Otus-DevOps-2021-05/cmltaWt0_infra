variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "subnet_id" {
  description = "Subnet"
}

variable "image_id" {
  description = "Image"
}

variable "zone" {
  description = "zone"
  default     = "ru-central1-a"
}

variable "public_key_path" {
  description = "Public key path"
}

variable "private_key_path" {
  description = "Private key path"
}

variable "service_account_key_file_path" {
  description = "Service account key path"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable env {
  description = "Environment name"
  default     = "dev"
}
