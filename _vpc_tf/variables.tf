variable "aws_region" {
  description 	= "aws region to deploy"
  default	= "us-west-2"
  type		= string
}

variable "ami_id" {
  description		= "aws ami for ec2 instance"
  default		= "ami-07d9cf938edb0739b"
}

variable "instance_type" {
  description		= "instance type for ec2"
  default		= "t2.micro"
}
