#!/bin/bash

# yum -y update
# yum -y install httpd


# myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

# cat <<EOF > /var/www/html/index.html
# <html>
# <body bgcolor="green">
# <h2><font color="gold">Build by Power of Terraform <font color="red"> v0.12</font></h2><br><p>
# <font color="green">Server PrivateIP: <font color="aqua">$myip<br><br>

# <font color="magenta">
# <b>Version 3.0</b>
# </body>
# </html>
# EOF

# sudo service httpd start
# chkconfig httpd on

sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker 
sudo usermod -aG docker ec2-user

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version
