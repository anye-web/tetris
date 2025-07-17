terraform {
  backend "s3" {
    bucket  = "demo-pro9"
    key     = "Jenkins/terraform.tfstate"
    region  = "us-east-1"
  }
}