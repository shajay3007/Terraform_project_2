# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
}

# create subnet

resource "aws_subnet" "Public_subnet1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pub_subnet_ip
  availability_zone = var.av_zone
  map_public_ip_on_launch = true
}

resource "aws_security_group" "public_sg1" {
  vpc_id = aws_vpc.my_vpc.id

 ingress {
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


dynamic "ingress" {
    for_each = [ 22, 80, 443, 465, 25, 6443 ]
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    }
}

# Internet Gateway creation

resource "aws_internet_gateway" "my_IGW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    name = "Terraform_IGW"
  }
}
# Create Route Table
resource "aws_route_table" "Terra_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IGW.id
    }
      tags = {
    Name = "my_route_table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.Public_subnet1.id
  route_table_id = aws_route_table.Terra_route_table.id
}


# user data
data "template_file" "user_data" {
  template = <<-EOF
  #!/bin/bash/
  yum update -y
  yum install -y python3
  pip3 install ansible
  EOF
}


#create instances
 resource "aws_instance" "myec_2" {
  count = 1
  subnet_id = aws_subnet.Public_subnet1.id
  security_groups = [aws_security_group.public_sg1.id]
  instance_type   = "t2.micro"
 ami = "ami-0e86e20dae9224db8"
 key_name = "Devops_key"
 user_data = data.template_file.user_data.rendered

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 10  # Size in GB
    volume_type = "gp2"
  }
  tags = {
  name = "Jenkins_server"
 }
}
