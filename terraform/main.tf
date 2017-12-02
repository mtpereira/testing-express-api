provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "instances" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${length(data.aws_availability_zones.available.names)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)}"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "elb" {
  name        = "testing-express-api-elb"
  description = ""
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = "${var.service_port}"
    to_port     = "${var.service_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instances" {
  name        = "testing-express-api"
  description = ""
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "default" {
  name            = "testing-express-api"
  subnets         = ["${aws_subnet.instances.*.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = "${var.app_port}"
    instance_protocol = "http"
    lb_port           = "${var.service_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.app_port}/health"
    interval            = 5
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 5
  connection_draining         = true
  connection_draining_timeout = 60
}

resource "aws_key_pair" "default" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "aws_ami" "instances" {
  owners      = ["595879546273"]
  most_recent = true

  filter {
    name   = "description"
    values = ["CoreOS Container Linux stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-config.yml.tpl")}"

  vars {
    app_name     = "${var.app_name}"
    app_port     = "${var.app_port}"
    app_version  = "${var.app_version}"
    docker_image = "${var.docker_image}"
  }
}

resource "aws_launch_configuration" "default" {
  lifecycle {
    create_before_destroy = true
  }

  image_id        = "${data.aws_ami.instances.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instances.id}"]
  key_name        = "${var.key_name}"
  user_data       = "${data.template_file.cloud_config.rendered}"
}

resource "aws_autoscaling_group" "default" {
  lifecycle {
    create_before_destroy = true
  }

  name                = "${aws_launch_configuration.default.name}"
  load_balancers      = ["${aws_elb.default.name}"]
  vpc_zone_identifier = ["${aws_subnet.instances.*.id}"]
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2
  min_elb_capacity    = 1

  launch_configuration = "${aws_launch_configuration.default.name}"
}
