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
