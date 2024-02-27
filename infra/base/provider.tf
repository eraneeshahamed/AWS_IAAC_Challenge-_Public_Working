# Setup our aws provider
variable "region" {
  default = "us-east-1"
}
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "news4421-terraform-infra-na"
    region = "us-east-1"
    dynamodb_table = "news4421-terraform-locks"
    key = "base/terraform.tfstate"
  }
}

