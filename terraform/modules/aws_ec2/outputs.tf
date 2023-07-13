output "ec2_id" {
  value = aws_instance.main_ec2[*].public_ip
}
