terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "subnets" {
  source = "../../modules/subnets"

  vpc_id                = module.vpc.vpc_id
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
  name_prefix           = local.name_prefix
  tags                  = local.common_tags
}

module "igw" {
  source = "../../modules/igw"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  name_prefix       = local.name_prefix
  tags              = local.common_tags
}

module "nat" {
  source = "../../modules/nat"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  name_prefix        = local.name_prefix
  tags               = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.subnets.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
  tags              = local.common_tags
}

module "launch_template" {
  source = "../../modules/launch-template"

  name_prefix           = local.name_prefix
  instance_type         = var.instance_type
  key_name              = var.key_name
  security_group_id     = module.security_groups.ec2_security_group_id
  instance_profile_name = module.iam.ec2_instance_profile_name
  tags                  = local.common_tags
}

module "asg" {
  source = "../../modules/asg"

  name_prefix        = local.name_prefix
  subnet_ids         = module.subnets.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  launch_template_id = module.launch_template.launch_template_id
  min_size           = var.asg_min_size
  max_size           = var.asg_max_size
  desired_capacity   = var.asg_desired_capacity
  tags               = local.common_tags
}