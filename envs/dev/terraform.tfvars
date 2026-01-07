vpc_cidr = "10.0.0.0/16"

tags = {
  Project     = "secure-aws-terraform"
  Environment = "dev"
  Owner       = "DevOps"
}

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.101.0/24",
  "10.0.102.0/24"
]

ami_id        = "ami-00ca570c1b6d79f36"
instance_type = "t3.small"

min_size         = 1
max_size         = 2
desired_capacity = 1
