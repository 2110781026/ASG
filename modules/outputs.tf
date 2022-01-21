output "service-url" {
  value = "http://${aws_elb.head_elb.dns_name}/index.html"
}