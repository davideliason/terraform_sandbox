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
  security_groups	= [aws.security_group.instance.id]

  user_data = <<-EOF
		#!/bin/bash
		yum update -y                   
		yum install -y httpd
		echo "<h2>hello</h2>" > var/www/html/index.html
		systemctl start httpd
		systemctl enable httpd
		EOF
}
