#!/bin/bash

sleep 30

# sudo yum install java-1.8.0-openjdk -y
# sudo yum install epel-release -y
sudo amazon-linux-extras install epel -y
sudo yum update -y
sudo yum install redis -y
sudo yum install ufw -y
sudo systemctl start ufw
sudo systemctl enable ufw
sudo systemctl start redis
sudo systemctl enable redis
sudo ufw allow 6379
sudo ufw reload
# sudo echo "bind 0.0.0.0" >> /etc/redis.conf
sudo mv /home/ec2-user/redis.conf /etc/
# sudo amazon-linux-extras install redis6
sudo service redis restart