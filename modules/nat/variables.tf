variable "public_subnet_id" {
  description = "Public subnet ID where NAT Gateway will be created"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
