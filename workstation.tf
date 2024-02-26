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
  iam_instance_profile                = "role-for-workstation"

  tags = {
    Name        = "workstation-eksctl"
    Terraform   = "true"
    Environment = "dev"
  }
}
