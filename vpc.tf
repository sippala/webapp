#data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block       = "${var.cidr_block}"

  tags = {
    Name = "My VPC"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "My IGW"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_igw.id}"
  }

  tags {
    Name = "My RTB"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "My private RTB"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = "${var.subnet_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  #availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "My Public Subnet.${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = "${var.private_subnet_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_cidrs[count.index]}"
  #availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "My Private Subnet.${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count           = "${aws_subnet.public_subnet.count}"
  route_table_id  = "${aws_route_table.public_route_table.id}"
  subnet_id       = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on      = ["aws_route_table.public_route_table", "aws_subnet.public_subnet"]
}

resource "aws_route_table_association" "private_subnet_association" {
  count           = "${aws_subnet.private_subnet.count}"
  route_table_id  = "${aws_route_table.private_route_table.id}"
  subnet_id       = "${aws_subnet.private_subnet.*.id[count.index]}"
  depends_on      = ["aws_route_table.private_route_table", "aws_subnet.private_subnet"]
}
