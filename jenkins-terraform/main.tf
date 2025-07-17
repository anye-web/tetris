# Create iam role
resource "aws_iam_role" "pro9_role" {
  name = "pro9_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

  tags = {
    tag-key = "pro9_role"
  }
}

# Create iam role policy attachment.
resource "aws_iam_role_policy_attachment" "pro9-attach" {
  role       = aws_iam_role.pro9_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create iam role porfile

resource "aws_iam_instance_profile" "pro9_profile" {
  name = "test_profile"
  role = aws_iam_role.pro9_role.name
}

# Create Security group

resource "aws_security_group" "pro9_sg" {
    name        = "pro9_sg"
    description = "Allow TLS inbound traffic and all outbound traffic"
    
# Ingress role
    ingress = [
        for port in [22, 80, 443, 8080, 9000, 3000] : {
            description      = "TLS from VPC"
            from_port        = port
            to_port          = port
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            security_groups  = []
            self             = false

        }
    ]
   

# Egress
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
    }

    tags = {
        Name = "pro9_tls"
    }
}

# Create an aws Ec2 instance

resource "aws_instance" "pro9" {
  ami                     = "ami-020cba7c55df1f615"
  instance_type           = "t2.large"
  key_name                = "pro9-key"
  vpc_security_group_ids  = [aws_security_group.pro9_sg.id]
  user_data               = templatefile("./install_jenkins.sh", {})
  iam_instance_profile    =  aws_iam_instance_profile.pro9_profile.name



    tags = {
    Name = "pro9 Server"
  }

#   Create volume
 
    root_block_device {
      volume_size = 30
    }
}
