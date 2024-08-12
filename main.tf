provider "aws" {
  region = "us-west-2" 
}

resource "aws_vpc" "main" { 
   cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id  = aws_vpc.main.id
  cidir_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gw"  {
  vpc_id  = aws_vpc.main.id
}

resource "aws_route_table" "rt"  {
  vpc_id  = aws_vpc.main.id
  
  route {
     cidr_block = "0.0.0.0/0"

}
}

resource "aws_route_table_association"  "a" {

  subnet_id  = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id

}


resource "aws_security_group"  "allow_ssh"  {
   vpc_id  = aws_vpc.main.id
   ingress  { 
      from_port  = 22
      to_port  =  22
      protoclol =  "tcp"
      cidr_block = "0.0.0.0/0"

 } 
  egress {
   from_port = 0
   to_port  = 0 
   protocol = "-1"

  }
}

resource "aws_instance"  "Testinstance"  {
  ami  = "ami-0a38c1c38a15fed74"
  instance_type = "t2.nano"
  subnet_id = "aws_subnet.main.id"
  security_groups [
      aws_security_group.allow_ssh.name
]
tags = {
   Name  = "TerraformExampleInstance"

}

}

output "instance_public_ip"  {
value = aws_instance.Testinstance.public_ip
}













