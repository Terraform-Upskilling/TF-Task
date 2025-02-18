variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

}



variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default = ["10.0.3.0/24"]
}

variable "public_subnet_azs" {
  description = "List of availability zones for public subnets"
  type        = list(string)
  default = ["us-east-1a"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default = ["10.0.4.0/24"]
}

variable "private_subnet_azs" {
  description = "List of availability zones for private subnets"
  type        = list(string)
  default = ["us-east-1b"]
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default  = 2
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default = "ami-053a45fff0a704a47 "
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default = "t2.micro"
}
