#!/bin/bash
source ./common.sh
#calling common.sh file to avoid code redundancy    
cehck_rootaccess
#check if current user has root access  

app_name="user" 
app_setup
#calling app_setup function from common.sh      
nodejs_installation
#calling nodejs installation function from common.sh    

systemd_setup
#calling systemd setup function from common.sh
app_restart
#calling app_restart function from common.sh
