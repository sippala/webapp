data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "security_group" {
  name        = "${var.name}"
  description = "${var.description}"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress     = ["${var.ingress}"]
  egress      = ["${var.egress}"]
}
