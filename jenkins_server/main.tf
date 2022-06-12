resource "aws_iam_role" "aws_access" {
  name = var.aim_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/IAMFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = var.aim_profile_name
  role = aws_iam_role.aws_access.name
}

resource "aws_instance" "tf-jenkins-server" {
  ami                    = var.myami
  instance_type          = var.instancetype
  key_name               = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-jenkins-sec-gr.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name
  tags = {
    Name = var.tag
  }
  user_data = file("jenkins.sh")
}

resource "aws_security_group" "tf-jenkins-sec-gr" {
  name = var.jenkins-sg
  tags = {
    Name = var.jenkins-sg
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
