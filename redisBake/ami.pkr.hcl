packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "moreira-redis" {
  ami_name = "moreira-redis-${local.timestamp}"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  instance_type = "t2.micro"
  region = "us-east-1"
  tags              = {
    Name             = "moreira-redis"
    Owner            = "moreirajunior"
    Project          = "tema20"
    EC2_ECONOMIZATOR = "TRUE"
    CustomerID       = "ILEGRA"
  }
  ssh_username = "ec2-user"
  shutdown_behavior = "terminate"
  ssh_keypair_name = "kp-devops-moreirajunior"
  ssh_private_key_file = "/home/jose/Downloads/kp-devops-moreirajunior.pem"
}

build {
  name = "moreira-redis"
  sources = [
    "source.amazon-ebs.moreira-redis"
  ]

  # provisioner "ansible" {
  #   playbook_file = "playbook.yml"
  # }

  provisioner "file" {
    source = "redis.conf"
    destination = "/home/ec2-user/"
  }

  provisioner "shell" {
    script = "./prov.sh"
  }
}