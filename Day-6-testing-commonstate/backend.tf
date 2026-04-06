terraform {
  backend "s3" {
    bucket = "bucket-for-state-file-058264152807-us-east-1-an"
    #key    = "terraform.tfstate" #if same pth already using in diff directory not a good practice to use here
    key     = "day6/terraform.tfstate" #good practice to use here
    region = "us-east-1"
    use_lockfile = true
  }
}
# here we are using the same bucket but different key for different days so that we can have separate state files for each day
#if we use common s3 path for two diff directories you may destory or modify existing resources 