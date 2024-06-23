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
  profile = var.profile
}

module "rds" {
  source                 = "./rds"

  vpc_id                 = module.vpc.vpc_id
  env                    = var.env
  app_name               = var.app_name
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  db_password            = var.db_password
}

module "ecs" {
  source = "./ecs"

  vpc_id                     = module.vpc.vpc_id
  env                        = var.env
  app_name                   = var.app_name
  public_subnets             = module.vpc.public_subnets
  private_subnets            = module.vpc.private_subnets
}

module "amplify" {
  source = "./amplify"

  env                        = var.env
  app_name                   = var.app_name
  ecs_endpoint               = module.ecs.endpoint
  github_token               = var.github_token
}
