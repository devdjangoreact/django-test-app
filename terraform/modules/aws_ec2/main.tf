
#-------------------------------------------------------------------------------

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


resource "aws_instance" "main_ec2" {
  count                  = var.count_ec2_instance
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = element(var.subnets, count.index)
  user_data              = file("./user_data.sh")

  associate_public_ip_address = true
  tags = {
    Name = "${var.env}-ec2"
  }
}
