#!/bin/bash
source ./common.sh
#calling common.sh file to avoid code redundancy
cehck_rootaccess
#check if current user has root access

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
validate $? "Rabbitmq repo setup"   

dnf install rabbitmq-server -y &>>$log_file
validate $? "Rabbitmq installation"

systemctl enable rabbitmq-server &>>$log_file
validate $? "Rabbitmq enable"
systemctl start rabbitmq-server &>>$log_file
validate $? "Rabbitmq start"    

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

validate $? "Rabbitmq user creation"

echo -e "Script execution completed at : $(date) $G Successful $N" | tee -a $log_file