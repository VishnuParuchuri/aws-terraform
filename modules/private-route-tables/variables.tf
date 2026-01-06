variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
