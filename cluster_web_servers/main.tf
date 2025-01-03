terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port	= 0
    to_port	= 0
    protocol	= "-1"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "example" {
  image_id		= "ami-07d9cf938edb0739b"
  instance_type		= "t2.micro"

  network_interfaces {
  associate_public_ip_address	= true
  security_groups		= [aws_security_group.instance.id]
  }
  
}

resource "aws_autoscaling_group" "example" {
  launch_template {
	id 	= aws_launch_template.example.id
   	version	= "$Latest"
        }

  vpc_zone_identifier	= data.aws_subnets.default.ids
  
  min_size		= 2
  max_size		= 10

  tag {
    key			= "Name"
    value		= "terraform-asg-example"
    propagate_at_launch	= true
  }
}

#use data source with filter to look up Default VPC
data "aws_vpc" "default" {
  default 	= true
}

data "aws_subnets" "default" {
  filter {
    name 	= "vpc-id"
    values 	= [data.aws_vpc.default.id]
  }
}

variable "server_port" {
  description 		= "The port used for HTTP"
  type			= number
  default		= 80
}

variable "security_group_name" {
  description		= "port 80 ok"
  type			= string
}

