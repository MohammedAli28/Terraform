provider "aws" {
  region  = "us-east-1"
  alias   = "testenv"
  profile = "test"
}
provider "aws" {
  region  = "us-west-2"
  alias   = "prodenv"
  profile = "prod"
}