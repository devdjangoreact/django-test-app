output "ec2_public_ip" {
  value = aws_instance.main_ec2[*].public_ip
}
