
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




# resource "aws_instance" "dev" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     count = 2
# #     tags = {
# #         Name = "dev-instance"  #so here we are creating 2 instances with same name
# #     }
#      tags = {
#         Name = "dev-instance-${count.index}"  #so here we are creating 2 instances with different name
# }
# }


#use case-2 different names for each instance
variable "env" {
    description = "environment name"
    default =["test","dev", "prod" ]
    type = list(string)
  #here first we have used 3 servers : test,dev,prod
  #when test server is removed , it deletes the prod environment, 
  #because it checks the position of the server, and pdates again test with dev and dev with prod server.
}
resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    count = length(var.env)
     tags = {
        Name = var.env[count.index]  #so here we are creating 3 instances with different name
       
}
}