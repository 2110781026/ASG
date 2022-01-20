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

<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title>Homepage-Virt-PT-Fernlehre-2</title>
	<script src="http://localhost:8080/virt_home.html"></script> <! --- Anpassen --->
</head>
<body>
	<div class="container">
	<header>
		<div class="header">
			<h1>Herzliche willkommen auf dem Top-Service!</h1>
		</div>
	</header>
		<div class="main">
			<h2>Virt-PT Fernlehre 2</h2>
		</div>
		<div class="feature">
			<h3>Microservice 1</h3>
			<p>Klicke auf den Button des Microservice 1:</p>
      <a href=http://${ADDRESSMS1}/index.html>Zurück</a>


		</div>
		<div class="feature">
			<h3>Microservice 2</h3>
			<p>Klicke auf den Button des Microservice 2:</p>
      <a href="http://${ADDRESSMS1}/index.html">Zurück</a>

		</div>
        <br>
	<footer>
		&copy;2022 Clemens Lasslesberger & Balazs Dekany, Virt-PT Fernlehre 2
	</footer>
	</div>
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


sudo docker run -p 8080:80 -v /app/data/www/index.html:/app/index.html -v /app/nginx.conf:/etc/nginx/conf.d/default.conf nginx

 