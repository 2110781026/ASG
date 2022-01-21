resource "aws_instance" "cloud" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  user_data = templatefile("${path.module}/templates/init_cloud.tpl",{port = 80, ADDRESS = aws_elb.head_elb.dns_name})
  vpc_security_group_ids = [aws_security_group.ingress-all-https.id,aws_security_group.ingress-all-ssh.id,aws_security_group.ingress-all-http.id, aws_security_group.elb_http.id]

  tags = {
    Name = "cloud"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
