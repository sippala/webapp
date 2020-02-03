resource "aws_security_group" "bastion_sg" {
  name        = "${var.bastion_profile_name}-sg"
  vpc_id      = "${aws_vpc.main.id}"

  ingress  {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress   {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "ELB-sg"
  vpc_id      = "${aws_vpc.main.id}"

  ingress  {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress   {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.web_profile_name}-sg"
  vpc_id      = "${aws_vpc.main.id}"

  ingress  {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    security_groups = ["${aws_security_group.bastion_sg.id}"]
  }
  ingress  {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 80
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }
  egress   {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "DB-sg"
  vpc_id      = "${aws_vpc.main.id}"

  ingress  {
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
    security_groups = ["${aws_security_group.web_sg.id}"]
  }
  egress   {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
