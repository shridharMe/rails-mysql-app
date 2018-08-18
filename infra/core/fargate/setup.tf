# we expect that s3 bucket "roche-devops-terraform-dev" and dynodb table "terraformLocks" is created
# with required policy

terraform {
  required_version = "~> 0.11.3"

  backend "s3" {
    bucket         = "myco-terraform-state"
    key            = "fargate/eu-west-1.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraformLocks2"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}
