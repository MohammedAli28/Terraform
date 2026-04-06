terraform {
  backend "s3" {
    bucket = "bucket-for-state-file-058264152807-us-east-1-an"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}