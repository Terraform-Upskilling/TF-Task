 #Create Vpc
 resource "aws_vpc" "main" {
   cidr_block           = var.vpc_cidr
   enable_dns_support   = true
   enable_dns_hostnames = true

 }




# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id           = aws_vpc.main.id
  cidr_block       = ["10.0.3.0/24","10.0.4.0/24"][count.index]
  availability_zone = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
count             = length(var.private_subnet_cidrs)
vpc_id           = aws_vpc.main.id
cidr_block       = var.private_subnet_cidrs[count.index]
availability_zone = var.private_subnet_azs[count.index]

tags = {
Name = "Private Subnet ${count.index + 1}"
}
}



# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public Route Table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Create Route for Internet Access
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  # Allow inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Security Group"
  }
}

# Launch EC2 Instances
resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     =  aws_subnet.public[count.index % length(var.public_subnet_cidrs)].id
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "Web Server"
  }
}
