#vpc vars
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

# subnet IP creation
variable "pub_subnet_ip" {
  default = "10.0.0.0/17"
}

variable "av_zone" {
    description = "availability zone of subnet"
    default = "us-east-1a"
}
