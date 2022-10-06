#!/bin/bash

sleep 30

# sudo yum update -y

# sudo yum install -y golang
# sudo amazon-linux-extras install collectd -y
# # sudo yum install collectd -y
# sudo cp /home/ec2-user/calculator/collectd.conf /etc/collectd/collectd.conf
# # sudo systemctl enable collectd
# # sudo systemctl start collectd
# sudo systemctl start collectd.service
# cd /home/ec2-user/calculator ; go build calculator.go

# sudo mv /tmp/calculator.service /etc/systemd/system/calculator.service
# sudo systemctl enable calculator.service
# sudo systemctl start calculator.service
# ---------------------------------------------------
sudo snap install go --classic
go
sleep 10
sudo apt-get update -y
sudo apt-get install collectd -y
sudo cp /home/ubuntu/calculator/collectd.conf /etc/collectd/collectd.conf
sudo /etc/init.d/collectd start
cd /home/ubuntu/calculator ; go build calculator.go
sudo mv /tmp/calculator.service /etc/systemd/system/calculator.service
sudo systemctl enable calculator.service
sudo systemctl start calculator.service