#! /bin/bash
sudo yum update -y
sudo yum install httpd git -y
sudo systemctl enable httpd
sudo systemctl start httpd