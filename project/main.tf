provider "aws" {
  region = "us-east-1"
}

# --------------------
# VPC
# --------------------
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "dev-vpc" }
}

# --------------------
# Subnets
# --------------------
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "public1" }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "public2" }
}

resource "aws_subnet" "frontend1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "frontend1" }
}

resource "aws_subnet" "frontend2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "frontend2" }
}

resource "aws_subnet" "backend1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "backend1" }
}

resource "aws_subnet" "backend2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "backend2" }
}

resource "aws_subnet" "rds1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.7.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "rds1" }
}

resource "aws_subnet" "rds2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "rds2" }
}

# --------------------
# Security Group
# --------------------
resource "aws_security_group" "common_sg" {
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------
# Bastion Hosts
# --------------------
resource "aws_instance" "bastion" {
  count = 2
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.common_sg.id]

  tags = {
    Name = "bastion-${count.index + 1}"
  }
}

# --------------------
# Frontend EC2
# --------------------
resource "aws_instance" "frontend" {
  count = 2
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.frontend[count.index].id
  vpc_security_group_ids = [aws_security_group.common_sg.id]

  tags = {
    Name = "frontend-${count.index + 1}"
  }
}

# --------------------
# Backend EC2
# --------------------
resource "aws_instance" "backend" {
  count = 2
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.backend[count.index].id
  vpc_security_group_ids = [aws_security_group.common_sg.id]

  tags = {
    Name = "backend-${count.index + 1}"
  }
}

# --------------------
# Frontend ALB
# --------------------
resource "aws_lb" "frontend_alb" {
  name = "frontend-alb"
  internal = false
  load_balancer_type = "application"
  subnets = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "frontend_tg" {
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.dev_vpc.id
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# --------------------
# Backend ALB
# --------------------
resource "aws_lb" "backend_alb" {
  name = "backend-alb"
  internal = true
  load_balancer_type = "application"
  subnets = aws_subnet.backend[*].id
}

resource "aws_lb_target_group" "backend_tg" {
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.dev_vpc.id
}

# --------------------
# RDS
# --------------------
resource "aws_db_subnet_group" "rds_subnet" {
  subnet_ids = aws_subnet.rds[*].id
}

resource "aws_db_instance" "database" {
  identifier = "database-1"
  engine = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = "Cloud123"

  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  skip_final_snapshot = true
}