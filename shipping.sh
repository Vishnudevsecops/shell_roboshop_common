#!/bin/bash
source ./common.sh
#calling common.sh file to avoid code redundancy            
cehck_rootaccess
#check if current user has root access

app_name="shipping"
app_setup
#calling app_setup function from common.sh      
maven_installation
#calling maven installation function from common.sh     

systemd_setup

dnf install mysql -y &>>$log_file
validate $? "mysql client"

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities' &>>$log_file
if [ $? -ne 0 ]; then
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$log_file
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

systemctl restart $app_name &>>$log_file
validate $? "$app_name restart"

echo -e "$app_name setup completed $G Successful $N" | tee -a $log_file