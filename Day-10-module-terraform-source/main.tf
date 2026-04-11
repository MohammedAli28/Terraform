module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = "t2.micro"
  subnet_id     = "subnet-0666acf3c6364bf7d"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
