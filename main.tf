# AWS Provider
provider "aws" {
  region = var.aws_region
}

# EC2 Instance
resource "aws_instance" "backend_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = ["sg-0f99ca2faa6a34e6e"]

  user_data = file("${path.module}/user-data/backend.sh")

  tags = {
    Name = "Flask-Server"
  }
}

resource "aws_instance" "frontend_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = ["sg-0e1f6e5037d6a373d"]

  user_data = file("${path.module}/user-data/frontend.sh")

  tags = {
    Name = "Express-Server"
  }
}