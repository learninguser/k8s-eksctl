module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                                = "workstation-eksctl"
  ami                                 = data.aws_ami.centos8.id
  instance_type                       = "t3.micro"
  create_spot_instance                = true
  spot_type                           = "persistent"
  spot_instance_interruption_behavior = "stop"
  vpc_security_group_ids              = [aws_security_group.allow_eksctl.id]
  subnet_id                           = "subnet-07eceea08298f25d3" # replace your default subnet id
  user_data                           = file("workstation.sh")
  
  tags = {
    Name        = "workstation-eksctl"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "allow_eksctl" {
  name        = "allow_eksctl"
  description = "created for eksctl"
  tags = {
    Name = "allow_eksctl"
  }

  ingress {
    description = "all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "centos8" {
  owners      = ["973714476881"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
