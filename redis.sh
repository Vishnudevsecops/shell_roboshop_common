#!/bin/bash

source ./common.sh
#calling common.sh file to avoid code redundancy    
cehck_rootaccess
#check if current user has root access  

app_name="redis"

dnf module disable $app_name -y &>>$log_file
validate $? "Redis module disable"
dnf module enable $app_name:7 -y &>>$log_file
validate $? "Redis module enable"
dnf install $app_name -y &>>$log_file
validate $? "Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Redis config"

systemctl enable $app_name &>>$log_file
validate $? "Redis enable"
systemctl start $app_name &>>$log_file
validate $? "$app_name start"