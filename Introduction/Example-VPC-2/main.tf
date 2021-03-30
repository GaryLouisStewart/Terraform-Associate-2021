resource "aws_instance" "nginx-instance" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = "t2.micro"
  subnet_id              = element(aws_subnet.public.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = "nginx-example"

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file("${path.module}/${var.private_key_path}")
  }

  provisioner "file" {
    content = <<EOF
access_key=
secret_key=
security_token=
use_https=
bucket_location= EU

EOF
    destination = "/home/ec2_user/.s3cfg"
}
  provisioner "file" {
    content = <<EOF
/var/log/nginx/*log {
  daily
  rotate 10
  missingok
  compress
  sharedscripts
  postrotate
  endscript
  lastaction
      INSTANCE_ID=`curl --silent http:/169.254.169.254/latest/meta-data/instace-id`
      sudo /usr/local/bin/s3cmd sync --config=/home/ec2-user/.s3cfg /var/log/nginx/ s3://${aws_s3_bucket.web_bucket.id}/nginx/$INSTANCE_ID/
}
EOF
    destination = "/home/ec2_user/nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo cp /home/ec2-user/.s3cfg /root/.s3cfg",
      "sudo cp /home/ec2-user/nginx /etc/logrotate.d/nginx",
      "sudo pip install s3cmd",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/index.html",
      "s3cmd get s3://${aws_s3_bucket.web_bucket.id}/website/Globo_logo_Vert.png",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/Globo_logo_vert.png /usr/share/nginx/html/Globo_logo_vert.png",
      "sudo logrotate -f /etc/logrotate.conf",
    ]
  }

  tags = merge(local.common_tags, { Name = "${var.environment}-nginx-${count.index}"})

}
