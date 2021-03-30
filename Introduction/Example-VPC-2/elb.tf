resource "aws_elb" "sn-web" {
  name = "nginx-elb"

  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.nginx-sg.id]
  instances       = aws_instance.nginx-instance.*.id
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:80/"
    timeout = 5
    unhealthy_threshold = 2
  }
  tags = merge(local.common_tags, { Name = "${var.environment}-nginx-elb"})
}