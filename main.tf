terraform {
    required_version = ">= 0.12"
    required_providers {
        vultr = {
            source = "vultr/vultr"
            version = "2.12.1"
        }
    }
}

provider "vultr" {
    api_key = var.vultr_api_key
}