#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel

sudo service docker start
sudo usermod -a -G docker ec2-user

mkdir -p /app/data/etc
mkdir /app/data/var
mkdir /app/data/www

SERVERNAME="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"

cat > /app/data/www/index.html<< EOF

<!doctype html>
<html>
  <head>
    <title>This is the title of the webpage!</title>
  </head>
  <body>
    <p>This is an example paragraph. Anything in the <strong>body</strong> tag will appear on the page, just like this <strong>p</strong> tag and its contents.</p>
  </body>
</html>


EOF

cat > /app/nginx.conf<< EOF

server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name  ($SERVERNAME); 

    location / {
        root   /app;
        index index.html;
    }
}


EOF


sudo docker run --rm -ti -p 8080:80 -v /app/data/www/index.html:/app/index.html -v /app/nginx.conf:/etc/nginx/conf.d/default.conf nginx

 