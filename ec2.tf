data "aws_ami" "amazon_linux_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow SSH and HTTP inbound traffic and all outbound traffic"
  # vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_ssh_http"
  }

  dynamic "ingress" {
        for_each = var.webserver_sg_ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = var.sg_cidr
        }
    }   

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.sg_cidr    
  }
}


resource "aws_instance" "web_server" {
  count = var.server_count
  ami           = data.aws_ami.amazon_linux_ami.id # "ami-04b6019d38ea93034"
  instance_type = var.instance_type
  # monitoring    = true
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name      = var.Key_pair_name  
  user_data = file("./scripts/httpd_setup.sh")

  tags = var.webserver_tags

}

resource "null_resource" "webserver_provisioning" {

  count = var.server_count
  depends_on = [ 
    aws_instance.web_server 
  ]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web_server[count.index].private_ip} >> private_ips.txt"
  } 

  connection {
    
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./server_key.pem")
    host     = "${aws_instance.web_server[count.index].public_ip}"
  }

  # Copies the project files to /tmp/
  provisioner "file" {
    source      = "./project/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    
    inline = [
      "sleep 60",
      "sudo cp /tmp/index.html /var/www/html/index.html",
    ]
  }

}
