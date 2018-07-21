terraform {
  required_version = "~> 0.11.3"
  backend "s3" {
    bucket         = "devops-terraform-state"
    key            = "eks/eu-west-1.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraformLocks"
  }
}
provider "aws" {
  region  = "eu-west-1"
  profile = "default" 
}