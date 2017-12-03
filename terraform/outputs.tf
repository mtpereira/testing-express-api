output "elb_address" {
  value = "${aws_elb.default.dns_name}"
}

output "ami_id" {
  value = "${data.aws_ami.instances.id}"
}

output "app_version" {
  value = "${var.app_version}"
}
