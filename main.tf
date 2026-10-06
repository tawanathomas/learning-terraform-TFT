provider "aws" {
  region = "us-east-1"
}

# 1. Query the latest official, secure Ubuntu 24.04 LTS image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Official Ubuntu Publisher)
}

# 2. Provision a small, free-tier eligible virtual server
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  # User data script to automatically install Java and Tomcat at launch
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y default-jdk
              sudo apt-get install -y tomcat9 tomcat9-admin
              sudo systemctl start tomcat9
              sudo systemctl enable tomcat9
              EOF

  tags = {
    Name = "Hello World"
  }
}
