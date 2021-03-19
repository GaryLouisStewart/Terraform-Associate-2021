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

output "aws_instance_public_dns" {
  value = aws_instance.nginx1.public_dns
}
