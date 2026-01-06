terraform {
  backend "s3" {
    bucket         = "secure-terraform-state-vishnu-001"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
