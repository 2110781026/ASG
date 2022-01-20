output "service-url" {
  value = "http://${aws_elb.main_elb.dns_name}/index.html"
}