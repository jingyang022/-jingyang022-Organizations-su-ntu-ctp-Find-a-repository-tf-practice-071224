variable "name" {
  description ="name of application"
  type = string
  default = "yap"
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["shared-vpc"]
  }
}

data "aws_subnets" "public" {
  filter{
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name = "tag:Name"
    values = ["*public-*"]
  }
}

data "aws_subnets" "private" {
  filter{
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name = "tag:Name"
    values = ["*private-*"]
  }
}

resource "aws_security_group" "example" {
    name_prefix = "${var.name}-sg" #Security group name, e.g. jazeel-terraform-security-group
    description = "Security group for EC2"
    vpc_id = data.aws_vpc.selected.id #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.example.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.example.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.example.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}