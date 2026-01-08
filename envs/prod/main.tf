data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}

module "subnets" {
  source = "../../modules/subnets"

  vpc_id               = module.vpc.vpc_id
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

module "igw" {
  source = "../../modules/igw"

  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "nat" {
  source = "../../modules/nat"

  public_subnet_id = module.subnets.public_subnet_ids[0]
  tags             = var.tags
}

module "public_route_table" {
  source = "../../modules/route-tables"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
  igw_id            = module.igw.igw_id
  tags              = var.tags
}

module "private_route_table" {
  source = "../../modules/private-route-tables"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.subnets.private_subnet_ids
  nat_gateway_id     = module.nat.nat_gateway_id
  tags               = var.tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "alb" {
  source = "../../modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.subnets.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  tags                  = var.tags
}

module "iam" {
  source = "../../modules/iam"
  tags   = var.tags
}

module "launch_template" {
  source = "../../modules/launch-template"

  ami_id                = var.ami_id
  instance_type         = var.instance_type
  ec2_security_group_id = module.security_groups.ec2_sg_id
  instance_profile_name = module.iam.instance_profile_name

  environment = "prod"
}

module "asg" {
  source = "../../modules/asg"

  launch_template_id = module.launch_template.launch_template_id
  private_subnet_ids = module.subnets.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  tags = var.tags
}
