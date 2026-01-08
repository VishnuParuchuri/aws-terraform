variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}
