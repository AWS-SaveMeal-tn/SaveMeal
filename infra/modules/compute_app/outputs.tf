output "instance_id" {
  value = aws_instance.frontend.id
}

output "private_ip" {
  value = aws_instance.frontend.private_ip
}

output "availability_zone" {
  value = aws_instance.frontend.availability_zone
}
