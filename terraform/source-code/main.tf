### run ec2 instance in defualt vpc

data "aws_availability_zones" "working" {}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t2.micro"

  tags = {
    Name    = "My Ubuntu Server"
    Owner   = "Solovka Dmytro"
    Project = "Terraform Lessons"
  }
}
