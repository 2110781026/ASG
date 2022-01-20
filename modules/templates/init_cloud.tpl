#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel

sudo service docker start
sudo usermod -a -G docker ec2-user

mkdir -p /app/data/etc/pics
mkdir /app/data/var
mkdir /app/data/www

SERVERNAME="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"

sudo wget -P /app/data/www https://raw.githubusercontent.com/2110781026/ASG/main/modules/cloud.jpg
 

echo ${ADDRESS} > /app/data/www/url.txt

cat > /app/data/www/index.html<< EOF

<html lang="en-US">
<head>

	<meta charset="UTF-8">
	<title>Microservice 2</title>
	<script src="http://localhost:8080/microservice_2.html"></script> <! --- Anpassen --->
</head>
<body>
	<div class="container">
	<header>
        <div class="header">
			<h1>Willkommen auf dem Microservice 2!</h1>
		</div>
        <img src="cloud.jpg" alt="Cloud_photo" width="500" height="600">
        <br>
        <! ---  <button class="GFG" --->
            <a href="http://${ADDRESS}/index.html">Zurück</a> 
    		 <! --- onclick="window.location.href = '${ADDRESS}:8080/index.html';"> Anpassen --->
        <! --- 	Zurück ---> 
		<! --- </button> --->
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


sudo docker run -p 8080:80 -v /app/data/www/cloud.jpg:/app/cloud.jpg -v /app/nginx.conf:/etc/nginx/conf.d/default.conf -v /app/data/www/index.html:/app/index.html nginx

 