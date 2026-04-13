variable "ami_id" {
    description = "passing values to ami_id"
    default = ""
    type = string
  
}
variable "instance_type" {
    description = "passing values to instance_type"
    default = ""
    type = string
  
}
variable "env" {
    description = "environment name"
    default =["test","dev", "prod" ]
    type = list(string)
    # so here when we removed test en , it will just destroy test server only.
}

resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    for_each = toset(var.env) #so here toset is used to convert list to set because for_each only accepts map and set not list
     tags = {
        Name = each.key  #so here we are creating 3 instances with different name
}
}