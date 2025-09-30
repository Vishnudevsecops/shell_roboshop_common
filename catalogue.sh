#!/bin/bash

source ./common.sh
#calling common.sh file to avoid code redundancy   
cehck_rootaccess
#check if current user has root access
app_name="catalogue"    

app_setup
#calling app_setup function from common.sh

nodejs_installation 
#calling nodejs installation function from common.sh        

systemd_setup   
#calling systemd setup function from common.sh  

# copy mongodb repo file 
cp $script_dir/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "Mongodb repo setup"
dnf install mongodb-mongosh -y &>>$log_file
validate $? "Mongosh client"

# Check if the catalogue database is already populated
INDEX=$(mongosh $mongodb_host --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")

if [ $INDEX -le 0 ]; then
    mongosh --host $mongodb_host </app/db/master-data.js &>>$log_file
    validate $? "Load catalogue products"
else
    echo -e "Catalogue products already loaded ... $Y SKIPPING $N"
fi

app_restart 
#calling app_restart function from common.sh
