provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"

  user_data = <<-EOF
		#!/bin/bash
		echo "hello world!" > index.html
		nohup busybox httpd -f -p 8080 &
		EOF

  user_data_replace_on_change = true

  tags = {
    Name = "tf-example"
  }
}

resource "aws_security_group" "instance" {
  name = "tf-example-instance2"

  ingress {
    from_port 	= 8080
    to_port 	= 8080
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}


