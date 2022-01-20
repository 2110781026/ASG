resource "aws_instance" "beard" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  user_data = templatefile("${path.module}/templates/init_beard.tpl",{port = 80})
  vpc_security_group_ids = [aws_security_group.ingress-all-https.id,aws_security_group.ingress-all-ssh.id,aws_security_group.ingress-all-http.id, aws_security_group.elb_http.id]

  tags = {
    Name = "beard"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
