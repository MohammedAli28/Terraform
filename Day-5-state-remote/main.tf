resource "aws_vpc" "dev-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "Dev-vpc"
    }
}
resource "aws_instance" "dev-instance" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"
  tags = {
    Name = "dev-instance"
  }
}