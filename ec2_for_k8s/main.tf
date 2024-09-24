

# Create VPC
resource "aws_vpc" "my_vpc" {
 # cidr_block = var.vpc_cidr
  cidr_block = var.vpc_cidr
}

# create subnet
resource "aws_subnet" "Public_subnet1" {
  vpc_id = aws_vpc.my_vpc.id
  #cidr_block = var.pub_subnet_ip
  cidr_block = var.pub_subnet_ip
  availability_zone = var.av_zone
  map_public_ip_on_launch = true
}

# security group for ec2
resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name        = "jenkins-sg"
  description = "Allow SSH, Jenkins, HTTP, and HTTPS traffic"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Adjust according to your security policy
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#  aws_internet_gateway 
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


resource "aws_instance" "jenkins_server" {
  ami                    = var.image_id  # AMI ID (replace with your region's AMI ID)
  instance_type          = var.ec2_type
  subnet_id              = aws_subnet.Public_subnet1.id  # Reference the created subnet
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  key_name = var.key_name  # SSH key for access

# ebs volume
ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 20  # Size in GB
    volume_type = "gp2"
  }
  # User data to install Jenkins, Docker, and Kubernetes
  user_data = <<-EOF
sudo dnf update
sudo dnf install java-17-amazon-corretto -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
	
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo docker run hello-world
newgrp docker
sudo usermod -aG docker ec2-user
sudo systemctl restart docker
docker ps -a
EOF

  tags = {
    Name = "Jenkins-Docker-K8s-Server"
  }
}
