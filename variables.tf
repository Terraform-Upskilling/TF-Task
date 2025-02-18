variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  default = "ami-053a45fff0a704a47"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default = "festkey"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  default = "vpc-03da1d4a34130599a"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  default = "192.168.0.0/24"
  type        = string
}
