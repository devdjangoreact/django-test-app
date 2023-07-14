variable "region" {
  description = "AWS Region where to provision VPC Network"
  default     = "us-west-1"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}


variable "instance_type" {
  default = "t2.micro"
}

variable "count_ec2_instance" {
  default = 1
}
