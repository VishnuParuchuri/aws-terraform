variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_security_group_id" {
  description = "Security group ID for EC2"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}
