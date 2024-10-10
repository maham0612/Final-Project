# provider block
provider "aws" {
    region = "eu-north-1"
    access_key = "xxx"
    secret_key = "xxx"
}

#resource block          
resource "aws_instance" "terraform_instance" {
    # Operating system image
    ami = "ami-04cdc91e49cb06165" #ubuntu ami image
    instance_type = "t3.micro"
    key_name = "ansible key pair"
    vpc_security_group_ids = [aws_security_group.first_security_group.id]
    user_data = file("${path.module}/user-data.sh")
    root_block_device {
    volume_size = 15  # Size in GB
  }
    tags = {
      Name = "Instance_from_terraform" #instance name
    }
  
}

#Security group
resource "aws_security_group" "first_security_group" {
  name        = "terraform_security_group"
  description = "Allow TLS inbound traffic"
  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Output block
output "public_ip" {
    value = "Public ip of instance is : ${aws_instance.terraform_instance.public_ip}"
  
}
