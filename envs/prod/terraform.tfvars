# Networking
vpc_cidr = "10.1.0.0/16"

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

public_subnet_cidrs = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnet_cidrs = [
  "10.1.101.0/24",
  "10.1.102.0/24"
]

# Compute
ami_id        = "ami-06f1fc9ae5ae7f31e"
instance_type = "t3.medium"

min_size         = 2
max_size         = 4
desired_capacity = 2

# Tags
tags = {
  Environment = "prod"
  Project     = "secure-aws-terraform"
  Owner       = "Vishnu"
}
