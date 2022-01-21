resource "aws_launch_configuration" "head-svc" {
  image_id = data.aws_ami.amazon-2.image_id
  instance_type = "t3.micro"
  user_data = base64encode(templatefile("${path.module}/templates/init_head.tpl", {port = 80, ADDRESSMS1 = aws_instance.beard.public_ip, ADDRESSMS2 = aws_instance.cloud.public_ip} ))
  security_groups = [aws_security_group.ingress-all-https.id,aws_security_group.ingress-all-ssh.id,aws_security_group.ingress-all-http.id, aws_security_group.elb_http.id]
  name_prefix = "${var.service_name}-head-svc-"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-head-svc" {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  desired_capacity   = var.desired_instances
  max_size           = var.max_instances
  min_size           = var.min_instances
  name = "${var.service_name}-head-asg"

  launch_configuration = aws_launch_configuration.head-svc.name

  health_check_type    = "ELB"
  load_balancers = [
    aws_elb.head_elb.id
  ]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup = "60"
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${var.service_name}-head-svc"
    propagate_at_launch = true
  }

}
resource "aws_elb" "head_elb" {
  name = "${var.service_name}-head-elb"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups = [
    aws_security_group.elb_http.id
  ]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}