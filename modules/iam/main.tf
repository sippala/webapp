resource "aws_iam_role" "role" {
  name               = "${var.role_name}"
  assume_role_policy = "${file("iam_trust_policy.json")}"
}

data "template_file" "policy" {
  template = "${file("iam_policy.json")}"
  vars {
    test_bucket = "${var.test_bucket}"
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${var.role_name}-iam-policy"
  policy = "${data.template_file.policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}
