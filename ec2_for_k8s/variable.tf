#---------------
#vpc Variables
#----------------
variable "vpc_cidr" {
  description = "provide the vpc cidr"
  default = ""
}
# subnet vars
variable "pub_subnet_ip"{
  description = "provide the vpc cidr"
  default = ""
}
# av zone
variable "av_zone"{
  description = "provide the vpc cidr"
  default = ""
}
# security groups vars


variable "allowed_ports" {
  description = "List of allowed ports for the security group"
  type        = list(number)
  default     = [22, 8080, 443]  # Example: SSH, Jenkins, HTTPS
}



########################
# ec2 variables
########################
variable "ec2_type" {
  description = "provide the ec2 type"
  default = "t2.micro"
}
# AMI ID
variable "image_id" {
  description = "provide the ami ID"
  default = "ami-0ebfd941bbafe70c6"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}