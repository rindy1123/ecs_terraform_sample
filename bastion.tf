resource "aws_key_pair" "ec2-bastion-host-key-pair" {
  key_name = "${var.profile}-ec2-bastion-host-key-pair-${var.env}"
  public_key = file("./id_rsa.pub")
}

resource "aws_security_group" "ec2-bastion-sg" {
  description = "EC2 Bastion Host Security Group"
  name = "${var.profile}-ec2-bastion-sg-${var.env}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open to Public Internet"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
    description = "IPv6 route Open to Public Internet"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "IPv4 route Open to Public Internet"
  }
}

resource "aws_eip" "ec2-bastion-host-eip" {
    domain = "vpc"
    tags = {
      Name = "${var.profile}-ec2-bastion-host-eip-${var.env}"
    }
}

resource "aws_instance" "ec2-bastion-host" {
    ami = "ami-0ab3794db9457b60a"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ec2-bastion-host-key-pair.key_name
    vpc_security_group_ids = [aws_security_group.ec2-bastion-sg.id]
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address = false
    tags = {
        Name = "${var.profile}-ec2-bastion-host-${var.env}"
    }
    lifecycle {
      ignore_changes = [ 
        associate_public_ip_address,
       ]
    }
}

resource "aws_eip_association" "ec2-bastion-host-eip-association" {
    instance_id = aws_instance.ec2-bastion-host.id
    allocation_id = aws_eip.ec2-bastion-host-eip.id
}
