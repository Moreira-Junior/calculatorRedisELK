terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.6.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "default_group" {
  id = "sg-812ea5f2"
}


data "aws_ami" "moreira-redis" {
  most_recent      = true
  name_regex       = "moreira-redis-*"
  owners           = ["self"]
}

data "aws_vpc" "vpc_default" {
    id = "vpc-fb859c82"
}

data "aws_subnet" "subnet_default" {
    id = "subnet-59599f66"
}

resource "aws_instance" "moreira-redis" {
    ami = data.aws_ami.moreira-redis.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.subnet_default.id
    security_groups = [data.aws_security_group.default_group.id]
    key_name = "kp-devops-moreirajunior"
    
    tags              = {
    Name             = "moreira-redis"
    Owner            = "moreirajunior"
    Project          = "tema20"
    EC2_ECONOMIZATOR = "TRUE"
    CustomerID       = "ILEGRA"
  }
}

# ADICIONAR TAGS
