variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}