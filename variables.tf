
variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID for your AWS region"
  type        = string
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}
