variable "vpc_cidr_block" {
  description = "This is our vpc cidr_block"
  default = "10.0.0.0/16"
  type = string
}

variable "cidr_pubsub1" {
  description = "This is the Cidr_block of our pubsub"
  default = "10.0.1.0/24"
  type = string
}

variable "cidr_privsub1" {
  description = "This is the Cidr_block for our privsub"
  default = "10.0.2.0/24"
  type = string
}

variable "AZ1"{
    description = "This is the AZ 1 for Pub sub"
    default = "eu-west-2a"
    type = string
}

variable "AZ2"{
    description = "This is the AZ 1 for Pub sub"
    default = "eu-west-2b"
    type = string
}

variable  "ami_instance" {
    description = " This is the AMI for our instance"
    default = "ami-08cd358d745620807"
    type = string
}

variable  "instance_type" {
    description = "This is the instance_type for our instance"
    default = "t2.micro"
    type = string
}