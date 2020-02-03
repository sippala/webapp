resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "dbsubnet_group"
  subnet_ids = ["${aws_subnet.private_subnet.*.id[1]}"]
}

resource "aws_db_instance" "main" {
  allocated_storage      = "${var.storage}"
  storage_type           = "${var.storage_type}"
  engine                 = "${var.engine}"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
}
