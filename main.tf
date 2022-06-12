resource "aws_instance" "managed_node" {
  ami                    = var.instance_ami
  count                  = var.instance_count
  instance_type          = var.managed_instance_type
  key_name               = var.keyname
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  iam_instance_profile   = var.iam_instance_profile
  tags = {
    Name        = "ansible_${element(var.tags, count.index)}"
    stack       = "ansible_project"
    environment = "development"
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name = var.security_group
  tags = {
    Name = var.security_group
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
