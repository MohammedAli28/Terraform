terraform {
  backend "s3" {
    bucket = "bucket-for-state-file-058264152807-us-east-1-an"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    #use_lockfile = true  #dynmodb no longer required for state locking in s3 backend we can use lockfile for state locking in s3 backend
    #terraform version shouid be 1.10 above to use lockfile for state locking in s3 backend
  }
}