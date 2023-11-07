terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region ="eu-west-2"
  access_key = "xxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxx"
}