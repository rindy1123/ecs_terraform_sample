data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name                         = "${var.app_name}-${var.env}-vpc"
  cidr                         = "10.0.0.0/16"
  azs                          = data.aws_availability_zones.available.names
  private_subnets              = local.private_subnets
  public_subnets               = local.public_subnets

  // For DNS
  enable_dns_hostnames         = true
  enable_dns_support           = true

  // For database
  create_database_subnet_group = true
  database_subnets             = local.database_subnets

  // For outbound internet access
  create_igw                   = true
  enable_nat_gateway           = true
}
