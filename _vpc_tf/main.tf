provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "sg" {
  name_prefix	= "asg-sg-"
  description= "allow ssh and http"

  ingress {
    description		= "ssh"
    from_port		= 22
    to_port		= 22
    protocol		= "tcp"
    cidr_blocks		= ["0.0.0.0/0"]
  }

  ingress {
    description		= "http"
    from_port		= 80
    to_port		= 80
    protocol		= "tcp"
    cidr_blocks		= ["0.0.0.0/0"]
  }
  
  egress {
    from_port		= 0
    to_port		= 0
    protocol		= "-1"
    cidr_blocks		= ["0.0.0.0/0"]
  }
  tags = {
    Name 		= "asg-sg"
  }
}

resource "aws_launch_template" "example" {
  name_prefix 		= "asg-launch-template-"
  image_id		= var.ami_id
  instance_type		= var.instance_type
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "friday-vpc-1"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "vpc_main_route_table_id" {
  value = module.vpc.vpc_main_route_table_id
}

output "vpc_public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "vpc_public_subnet_objects" {
  value = module.vpc.public_subnet_objects
}
