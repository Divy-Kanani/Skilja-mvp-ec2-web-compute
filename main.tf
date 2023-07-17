
resource "aws_iam_role" "web_instance_role" {
  name = "web-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_security_group" "web_instance_security_group" {
  name        = "web-instance-security-group"
  description = "Skilja web instance security group"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "skilja-web-instance-key"
  subnet_id     = split(",", data.aws_ssm_parameter.public_subnets.value)[0]

  vpc_security_group_ids = [aws_security_group.web_instance_security_group.id]
  iam_instance_profile   = aws_iam_role.web_instance_role.name

  tags = {
    Name = "web-instance"
  }
}


