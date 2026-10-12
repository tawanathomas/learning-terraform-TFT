data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    # Removed the backslash and updated the pattern to match newer gp3 storage formats
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-gp3"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"

  tags = {
    Name = "HelloWorld"
  }
}
