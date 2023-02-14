provider "aws" {
  region = "eu-west-2"
  profile = "Brenda"
}

terraform {
  backend "s3" {
  bucket = "cicd-awsnative"
  key = "build/terraform.tfstate"
  region = "eu-west-2"
  profile = "Brenda"
  }
}