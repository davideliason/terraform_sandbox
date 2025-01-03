provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"

  tags = {
    Name = "tf-example"
  }
}


