# instance 
resource "aws_instance" "tf-jenkins-server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-jenkins-sec-gr.id]
  iam_instance_profile   = aws_iam_instance_profile.tf-jenkins-server-profile.name
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 30
  }
  tags = {
    Name   = "Jenkins-Server"
    server = "Jenkins"
  }
  user_data = file("install.sh")
}

# Security Group 

resource "aws_security_group" "tf-jenkins-sec-gr" {
  name = "SG for Jenkins"
  tags = {
    Name = "jenkins-Server_SG"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# iAM /role resource
resource "aws_iam_role" "tf-jenkins-server-role" {
  name               = "Jenkins_server_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess", "arn:aws:iam::aws:policy/AdministratorAccess"]
}

# IAM instance profile to assign role

resource "aws_iam_instance_profile" "tf-jenkins-server-profile" {
  name = "jenkins_server_profile"
  role = aws_iam_role.tf-jenkins-server-role.name
}