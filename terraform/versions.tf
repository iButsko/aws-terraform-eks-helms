
# Terraform Block
#terraform {
#  required_version = ">= 1.0"
#  required_providers {
#    aws = {
#      source = "hashicorp/aws"
#      # version = "~> 3.0"
#    }
#  }
#}

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "devtest-terraform-state"
    key            = "main.tfstate"
    dynamodb_table = "devtest-terraform-state"
  }
}