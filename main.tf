terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "OrelAmzaleg-dev-vpc" {
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "OrelAmzaleg-dev-vpc"
  }
}

resource "aws_subnet" "OrelAmzaleg-k8s-subnet" {
  vpc_id     = aws_vpc.OrelAmzaleg-dev-vpc.id
  cidr_block = "192.168.1.0/27"

  tags = {
    Name = "OrelAmzaleg-k8s-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.OrelAmzaleg-dev-vpc.id

  tags = {
    Name = "gateway"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.OrelAmzaleg-dev-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}