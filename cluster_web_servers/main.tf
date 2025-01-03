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
  name = var.instance_security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "example" {
  image_id		= "ami-07d9cf938edb0739b"
  instance_type		= "t2.micro"
  security_groups	= [aws_security_group.instance.id]

  user_data = <<-EOF
		#!/bin/bash
		yum update -y                   
		yum install -y httpd
		echo "<h2>hello</h2>" > var/www/html/index.html
		systemctl start httpd
		systemctl enable httpd
		EOF

# req'd when using a launch config with ASG
  lifecycle {
    create_before_destroy	= true

  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration 	= aws_launch_configuration.example.name
  vpc_zone_identifier	= data.aws_subnets.default.ids
  
  min_size		= 2
  max_size		= 10

  tag {
    key			= "Name"
    value		= "terraform-asg-example"
    propogate_at_launch	= true
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

output "public_ip" {
  value			= aws_instance.example.public_ip
  description		= "public web server IP address"
}
