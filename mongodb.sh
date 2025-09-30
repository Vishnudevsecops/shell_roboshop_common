#!bin/bash
source ./common.sh
#calling common.sh file to avoid code redundancy

cehck_rootaccess
#check if current user has root access


cp mongodb.repo /etc/yum.repos.d/mongo.repo
validate $? "Mongodb repo setup"

dnf install mongodb-org -y &>>$log_file
validate $? "Mongodb"

systemctl enable mongod  &>>$log_file
validate $? "Mongodb enable"
systemctl start mongod &>>$log_file
validate $? "Mongodb start"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Allowing remote connections"

systemctl restart mongod &>>$log_file
validate $? "Mongodb restart"