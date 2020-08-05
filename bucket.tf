terraform {
  backend "s3" {
    bucket = "devopsterraformstate2020"
    key    = "terraform.tfstate"
    region = var.AWS_REGION
  }
}