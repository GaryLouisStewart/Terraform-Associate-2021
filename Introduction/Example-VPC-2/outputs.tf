output "aws_elb_public_dns" {
  value = aws_elb.sn-web.dns_name
}

output "common_tags" {
  value = local.common_tags
}

output "security_group_information" {
  value = {
    elb_sg_name       = aws_security_group.elb-sg.name,
    elb_sg_id         = aws_security_group.elb-sg.id,
    elb_sg_ingress    = aws_security_group.elb-sg.ingress,
    elb_sg_egress     = aws_security_group.elb-sg.egress,
    nginx_sg_name     = aws_security_group.nginx-sg.name,
    nginx_sg_id       = aws_security_group.nginx-sg.id,
    nginx_sg_ingress  = aws_security_group.nginx-sg.ingress,
    nginx_sg_egress   = aws_security_group.nginx-sg.egress
  }

  description = "Security group information, information about the elb and nginx instance security groups."
}