terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.44"
    }
  }
  backend "s3" {
    bucket  = "thesis-manuel-terraform-state-sysdig"
    key     = "terraform/eks-state/tfstate.json"
    access_key = var.backend_access_key
    secret_key = var.backend_secret_key
    region  = "eu-west-3"
    encrypt = true
  }
}

data "aws_availability_zones" "available" {}

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# module "vpc_instance" {
#   source = "./modules/vpc_module"
# }

# module "eks_instance" {
#   source = "./modules/eks_module"
# }
