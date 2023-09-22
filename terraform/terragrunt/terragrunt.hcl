remote_state {
    backend    = "s3"
    generate = {
      path  = "backend.tf"
      if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket  = "devtest-terraform-state"
        key     = "${path_relative_to_include()}/main.tfstate"
        region  = "us-east-1"
        dynamodb_table = "devtest-terraform-state"
    }   
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
  
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF

}


locals {
    aws_region = "us-east-1"
    deployment_prefix= "devtest-terragrunt"
}

inputs = {
    aws_region  = local.aws_region
    deployment_prefix = local.deployment_prefix
   
}