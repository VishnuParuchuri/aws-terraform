project_name = "secure-aws-app"
environment  = "prod"
aws_region   = "us-west-2"

vpc_cidr = "10.1.0.0/16"

public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
availability_zones   = ["us-west-2a", "us-west-2b"]

instance_type = "t3.small"
key_name      = "my-key-pair"

asg_min_size         = 2
asg_max_size         = 6
asg_desired_capacity = 3