#!/bin/bash
source ./common.sh
#calling common.sh file to avoid code redundancy    
cehck_rootaccess
#check if current user has root access  

dnf install mysql-server -y &>>$log_file
validate $? "Mysql installation"
systemctl enable mysqld &>>$log_file
validate $? "Mysql enable"
systemctl start mysqld &>>$log_file
validate $? "Mysql start"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
validate $? "Mysql secure installation"