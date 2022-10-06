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

source "amazon-ebs" "moreira-calculator" {
  ami_name = "moreira-calculator-${local.timestamp}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  instance_type = "t2.micro"
  region = "us-east-1"
  tags              = {
    Name             = "moreira-calculator"
    Owner            = "moreirajunior"
    Project          = "tema20"
    EC2_ECONOMIZATOR = "TRUE"
    CustomerID       = "ILEGRA"
  }
  ssh_username = "ubuntu"
  shutdown_behavior = "terminate"
  ssh_keypair_name = "kp-devops-moreirajunior"
  ssh_private_key_file = "/home/jose/Downloads/kp-devops-moreirajunior.pem"
}

build {
  name = "moreira-junior-go-calculator"
  sources = [
    "source.amazon-ebs.moreira-calculator"
  ]

  provisioner "file" {
    source = "./calculator"
    destination = "/home/ubuntu/calculator"
  }
    
  provisioner "file" {
    source = "./calculator.service"
    destination = "/tmp/calculator.service"
  }

  provisioner "shell" {
    script = "./prov.sh"
  }
}