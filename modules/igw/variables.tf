variable "vpc_id" {
  description = "VPC ID to attach the Internet Gateway"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
