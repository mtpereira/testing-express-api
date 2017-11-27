output "elb_address" {
  value = "${aws_elb.default.dns_name}"
}
