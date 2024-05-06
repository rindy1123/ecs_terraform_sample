terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.48"
    }
  }

  required_version = "~> 1.8.2"
}

provider "aws" {
  region  = var.region
  profile = "terraform"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name                 = "go-app"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets       = [var.private-subnet-1-cidr-block, var.private-subnet-2-cidr-block, var.private-subnet-3-cidr-block]
  public_subnets       = [var.public-subnet-1-cidr-block, var.public-subnet-2-cidr-block, var.public-subnet-3-cidr-block]
  enable_dns_hostnames = true
  enable_dns_support   = true
}
