resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "prod"
    }
  
}

resource "aws_subnet" "prod-subnet1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "prod-subnet1"
    }
  
}



resource "aws_subnet" "prod-subnet2" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "prod-subnet2"
    }
  
}