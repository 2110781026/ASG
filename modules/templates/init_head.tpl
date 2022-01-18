#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel

sudo service docker start
sudo usermod -a -G docker ec2-user

mkdir -p /app/data/etc
mkdir /app/data/var

SERVERNAME="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"

cat > /app/nginx.conf<< EOF
server {
    server_name  ($SERVERNAME).no.ip; 
    listen 80 default_server;
    listen [::]:80 default_server;


    #if ($scheme != "https") {
    #    return 301 https://$host$request_uri;
    #}

    location / {
        proxy_pass http://${target}/;
    }
}

EOF

sudo docker run -p 8080:80 -v /app/nginx.conf:/etc/nginx/conf.d/my.conf:ro --name nginx nginx

 