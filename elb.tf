data "aws_caller_identity" "current" {}

resource "aws_elb" "myelb" {
  name               = "test-elb"
  subnets            = ["${aws_subnet.public_subnet.*.id[0]}"]
  security_groups    = ["${aws_security_group.elb_sg.id}"]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${module.ec2_web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
