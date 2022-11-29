terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "~> 2.24.1"
    }
    # alicloud = {
    #   source  = "aliyun/alicloud"
    #   version = ">= 1.169.0"
    # }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}