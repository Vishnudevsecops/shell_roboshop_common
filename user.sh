#!/bin/bash
source ./common.sh
app_name="user" 
cehck_rootaccess
#check if current user has root access  


app_setup
#calling app_setup function from common.sh      
nodejs_installation
#calling nodejs installation function from common.sh    

systemd_setup
#calling systemd setup function from common.sh
app_restart
#calling app_restart function from common.sh
