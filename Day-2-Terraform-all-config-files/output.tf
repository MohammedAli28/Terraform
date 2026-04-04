output "public_ip" {
    value = aws_instance.bashion.public_ip  
}
output "private_ip" {
    value = aws_instance.bashion.private_ip
  
}
output "az" {
    value = aws_instance.bashion.availability_zone
  
}
