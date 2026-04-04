resource "aws_vpc" "prod_vpc" {
  provider = aws.prodenv
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod"
  }

}
resource "aws_subnet" "prod_subnets" {
  provider = aws.prodenv
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = "10.0.1.0/24"
  depends_on = [aws_vpc.prod_vpc]
  tags = {
    Name = "prod-subnet"
  }
}
resource "aws_security_group" "prod_sg" {
  provider = aws.prodenv
  name   = "prod-sg"
  vpc_id = aws_vpc.prod_vpc.id

  # inbound rule - SSH
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # inbound rule - HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound rule - allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-sg"
  }
}
resource "aws_instance" "prod" {
  provider      = aws.prodenv
  ami           = var.prod_ami_id
  instance_type = var.prod_instance_type
  subnet_id     = aws_subnet.prod_subnets.id
  vpc_security_group_ids = [
    aws_security_group.prod_sg.id
  ]
  tags = {
    Name = "prod-instance"
  }
}
resource "aws_instance" "test" {
  ami           = var.test_ami_id
  instance_type = var.test_instance_type
  provider      = aws.testenv
  tags = {
    Name = "test-instance"
  }
}

#if we are using test.tfvars or prod.tfvars then we have to pass the variables to explicitily.
#terraform apply -var-file="test.tfvars" -var-file="prod.tfvars" --auto-approve
# •	When multiple files define same variable:
# •	1. CLI -var / -var-file   (highest)
# 2. *.auto.tfvars
# 3. terraform.tfvars
# 4. variable default (lowest)
