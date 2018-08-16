# we expect that s3 bucket "roche-devops-terraform-dev" and dynodb table "terraformLocks" is created
# with required policy

terraform {
  required_version = "~> 0.11.3"

  backend "s3" {
    bucket         = "myco-terraform-state"
    key            = "eks-all/us-east-1.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraformLocks"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
  version = "~> 1.28"
  version = "~> 1.0"
}
