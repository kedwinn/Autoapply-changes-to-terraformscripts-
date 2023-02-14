#provision your vpc
resource "aws_vpc" "Test" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "Test"
  }
}

# Provision a public subnet and private subnet
resource "aws_subnet" "pubsub1" {
  vpc_id = aws_vpc.Test
  cidr_block = var.cidr_pubsub1
  availability_zone_id = var.AZ1
  map_public_ip_on_launch= true
  tags = {
    "Name" = "pubsub1"
  }
}

resource "aws_subnet" "privsub1" {
  vpc_id = aws_vpc.Test
  cidr_block = var.cidr_privsub1
  availability_zone_id = var.AZ2
  map_public_ip_on_launch = true
  tags = {
    "Name" = "privsub2"
  }
}

# Create an IGW an attach to VPC
resource "aws_internet_gateway" "Test-IGW" {
  vpc_id = aws_instance.Test.id
}

#create a 2 route table and 2 route associations
resource "aws_route_table" "pub-RT" {
  vpc_id = aws_vpc.Test.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Test-IGW.id
  }
}

resource "aws_route_table_association" "pubRTA" {
  subnet_id = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.pub-RT.id
}


resource "aws_route_table_association" "Priv-RT" {
  subnet_id = aws_subnet.privsub1.id
  route_table_id = aws_route_table.pub-RT.id
}

# create a key pair
resource "aws_key_pair" "citest" {
  key_name = "citest"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxETJN6UTDtkqGyCJXoduIAin/iQL/ymc40IonDc5M4TjJZNsL6KQrq4O4Cw/twIJzp1YMLbB+ogPcZ0oWEOKvCtjjH+o51AmDJatJQJBCpeBFuUmbZe8j8Sif7yOyw0PaRuoj2Yx85Mn5lcNolrE6HwVzlbNrWbaq+bevOr5vXwfKOfqPcEg49HKydrmS9ofNtqWhP1jBreGraDG8LjYflmsSORXnZOCSXwjwHI1EQTAg5PQb0lg5vmAIuHIxU20QL3r2s9TarNayocpMYbqLXIhkXGyUdWxJ2gRNZVA1eVpbVbYH6Rp5+fXq3TZbP2mQHos0tLDbvrDNBrCdOqu3atiUsrpUa+ZBXL4R+Xs6Mea+RKgio2BtX5PhbIepJXCPtouPjmqGowGALApZGGSneYk6AU3uZP/WKKZz+y1czvfUXDbhRHG8OZ8dVNA9vKJkzlgAOyW8ravnc2kBhsLd6n7dzjjv6L6SCHc2GmErO9PnXbmfsnnL59gzttirX7U= admin@PF313WVE-JDV"
}


#provision your ec2 instance and attach user-data script that installs Jenkins 
resource "aws_instance" "Test" {
  ami = var.ami_instance
  instance_type = var.instance_type
  subnet_id =  aws_subnet.pubsub1.id
  key_name = "citest"
  security_groups = [aws_security_group.citest-sg.id]
  user_data = file("install_apps.sh")
}

 # Provision your security groups
resource "aws_security_group" "citest-sg" {
  vpc_id = aws_vpc.Test.id
  name = "citest-sg"
  description = "Allow inbound access to port 80 and 443"
  

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}