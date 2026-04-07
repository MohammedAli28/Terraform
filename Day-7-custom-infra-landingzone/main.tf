# Creation of VPC, Subnet, Internet Gateway, Route Table, and Security Group
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "prod-vpc"
    
    }
}

#public subnet
resource "aws_subnet" "prod-pub-subnet" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "prod-pub-subnet"
    }
}

resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
        Name = "prod-internet-gateway"
    }
}
#create route table and associate with public subnet
resource "aws_route_table" "prod-pub-rt" {
  vpc_id = aws_vpc.prod-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-igw.id

    }
}

resource "aws_route_table_association" "prod-rt-tb-ass" {
    subnet_id = aws_subnet.prod-pub-subnet.id
    route_table_id = aws_route_table.prod-pub-rt.id
}

#security group

resource "aws_security_group" "prod-sg" {
    name = "prod-sg"
    description = "Allow SSH and HTTP traffic"
    vpc_id = aws_vpc.prod-vpc.id
    
    #inbound rule to allow SSH traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #outbound rule to allow all traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#instance public
resource "aws_instance" "prod-public-instance" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.medium"
    subnet_id = aws_subnet.prod-pub-subnet.id
    vpc_security_group_ids = [aws_security_group.prod-sg.id]
    tags = {
        Name = "prod-public-instance"
    }
    
}

#private subnet
resource "aws_subnet" "prod-private-subnet" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "prod-private-subnet"
    }
}

# ---------------------------
# Elastic IP for NAT
# ---------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# ---------------------------
# NAT Gateway
# ---------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.prod-pub-subnet.id

  depends_on = [aws_internet_gateway.prod-igw]
}
# ---------------------------
# Private Route Table
# ---------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.prod-vpc.id
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.prod-private-subnet.id
  route_table_id = aws_route_table.private_rt.id
}

#instance private
resource "aws_instance" "prod-private-instance" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.medium"
    subnet_id = aws_subnet.prod-private-subnet.id
    vpc_security_group_ids = [aws_security_group.prod-sg.id]
    tags = {
        Name = "prod-private-instance"
    }
    
}