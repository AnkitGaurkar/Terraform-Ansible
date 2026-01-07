

# 🔑 Key pair
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-ansible-terra-key-ec2"
  public_key = file("ansible-terra-key-ec2.pub")

tags = {
  Environment = var.env
}
  
}

# 🖧 Default VPC
resource "aws_default_vpc" "default" {}

# 🛡 Security Group
resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-ansible-automate-sg"
  description = "This will add a TF genrated Security group"
  vpc_id      = aws_default_vpc.default.id   #interpolation

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-automate-sg"
  }
}

# 🖥 EC2 instance
resource "aws_instance" "my_instance" {

for_each = tomap({

  Ankit-Ansible-Master= "ami-049442a6cf8319180"  #Ubuntu
  Ankit-Ansible-1= "ami-0b93e28d1386a8580"  #Red Hat
  Ankit-Ansible-2= "ami-09c54d172e7aa3d9a" #CenOS (Amazon Linux)

                 #@MetaArgument with Key and Value pair
})

depends_on = [aws_security_group.my_security_group,aws_key_pair.my_key]

  instance_type = "t3.micro"

  ami = each.value

  key_name               = aws_key_pair.my_key.key_name

  security_groups =  [aws_security_group.my_security_group.name]
    

  root_block_device {

    #volume_size = 8
    volume_size = each.value== "ami-0b93e28d1386a8580" ? 10 : 8

    volume_type = "gp3"
  }
  
tags = {
  Name = each.key
  Environment = var.env
}
}