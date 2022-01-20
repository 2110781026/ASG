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

sudo wget -P /app/data/www https://raw.githubusercontent.com/2110781026/ASG/main/modules/beard.jpg

cat > /app/data/www/index.html<< EOF

<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title>Microservice 1</title>
	<script src="http://localhost:8080/index.html"></script>
</head>
<body>
	<div class="container">
	<header>
		<div class="header">
			<h1>Willkommen auf dem Microservice 1!</h1>
		</div>
        <div class="h3">
            <h3>Es ist ein Scnurrbart:</h3>>
        </div>
        <img src="beard.jpg" alt="schnurrbart_photo" width="290" height="174">
        <br>
	</header>
	<button class="GFG" 
    		onclick="window.location.href = 'virt_home.html';"> <! --- Anpassen --->
        	Zurück
	</button>
	<br>
	<footer></footer>
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


sudo docker run -p 8080:80 -v /app/data/www/beard.jpg:/app/beard.jpg -v /app/nginx.conf:/etc/nginx/conf.d/default.conf -v /app/data/www/index.html:/app/index.html nginx

 