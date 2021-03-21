resource "aws_instance" "nginx1" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.sn1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = "nginx-example"

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file("${path.module}/${var.private_key_path}")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "echo '<html><head><title>Blue team server</title></head><body style=\"background-color:#1F778D\"></html>'"
    ]
  }
}

resource "aws_instance" "nginx2" {
  ami = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sn2.id
  vpc_security_group_ids = [
    aws_security_group.nginx-sg.id]
  key_name = "nginx-example"

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file("${path.module}/${var.private_key_path}")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "echo '<html><head><title>Green team server</title></head><body style=\"background-color:#1F778D\"></html>'"
    ]
  }
}

resource "aws_elb" "sn-web" {
  name = "nginx-elb"

  subnets         = [aws_subnet.sn1.id, aws_subnet.sn2.id]
  security_groups = [aws_security_group.nginx-sg.id]
  instances       = [aws_instance.nginx1.id, aws_instance.nginx2.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

output "aws_elb_public_dns" {
  value = aws_elb.sn-web.dns_name
}
