
resource "aws_security_group" "ec2_sg" {
name        = "ec2-security-group"
description = "Allow SSH and HTTP traffic"




ingress {
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "ec2_instance" {
ami                    = "ami-053a45fff0a704a47"
instance_type          ="t2.micro"
security_groups        = [aws_security_group.ec2_sg.name]


tags = {
Name = "Terraform-EC2"
}
}

resource "aws_eip" "elastic_ip" {

}
resource "aws_eip_association" "eip_assoc" {
instance_id   = aws_instance.ec2_instance.id
allocation_id = aws_eip.elastic_ip.id
}
