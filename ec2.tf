data "template_file" "script_file" {
  template = "${file("${var.script_file}")}"
}

resource "aws_eip" "eip" {
  count = "${var.eip_count}"
}

resource "aws_nat_gateway" "gw" {
  count           = "${var.eip_count}"
  allocation_id   = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id       = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on      = ["aws_internet_gateway.my_igw"]
}

module "iam" {
  source          = "./modules/iam"
  role_name       = "${var.role_name}"
  test_bucket     = "${var.test_bucket}"
}

module "ec2_bastion" {
  source                 = "./modules/ec2"
  ec2_profile_name       = "${var.bastion_profile_name}"
  role_name              = "${module.iam.name}"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.public_subnet.*.id[0]}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  public_ip              = "${var.bastion_public_ip_allow}"
  disk_size              = "${var.disk_size}"
  command                = "${data.template_file.script_file.rendered}"
  tag_name               = "${var.bastion_tag_name}"
}

module "ec2_web" {
  source                 = "./modules/ec2"
  ec2_profile_name       = "${var.web_profile_name}"
  role_name              = "web-${module.iam.name}"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.private_subnet.*.id[0]}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  public_ip              = "${var.web_public_ip_allow}"
  disk_size              = "${var.disk_size}"
  command                = "${data.template_file.script_file.rendered}"
  tag_name               = "${var.web_tag_name}"
}
