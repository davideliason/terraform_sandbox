terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami			 = "ami-07d9cf938edb0739b"
  instance_type		 = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  user_data = <<-EOF
		#!/bin/bash
		yum update -y                   
		yum install -y httpd
		echo "<h2>hello</h2>" > var/www/html/index.html
		systemctl start httpd
		systemctl enable httpd
		EOF

  user_data_replace_on_change = true

  tags = {
    Name = "brand-new-instance!"
  }
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web-server-sg"

  ingress {
    from_port 	= 80
    to_port 	= 80
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
  
  egress {
    from_port	= 0
    to_port	= 0
    protocol	= "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "WebServerSG"
   }
  }
