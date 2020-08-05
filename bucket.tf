terraform {
  backend "s3" {
    bucket = "devopsterraformstate2020"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}