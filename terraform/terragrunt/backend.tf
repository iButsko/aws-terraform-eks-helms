# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "devtest-terraform-state"
    dynamodb_table = "devtest-terraform-state"
    key            = "./main.tfstate"
    region         = "us-east-1"
  }
}
