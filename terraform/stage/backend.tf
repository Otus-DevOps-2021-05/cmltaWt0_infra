terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "cmltawt0-infra-terraform"
    region     = "ru-central1"
    key        = "stage/terraform.tfstate"
    access_key = "xxxxxxxxxxxxxxxxxxxx"
    secret_key = "xxxxxxxxxxxxxxxxxxxx"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
