provider "aws"{
    
}
resource "aws_instance" "name" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.medium"
    tags = {
        Name = "test-instance"
    }   
  
}

resource "aws_instance" "imp" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t2.medium"
    tags = {
        Name = "dev-instance"
    }   
  
}