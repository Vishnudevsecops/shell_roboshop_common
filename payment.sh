#!/bin/bash
source ./common.sh
#calling common.sh file to avoid code redundancy        
cehck_rootaccess
#check if current user has root access
app_name="payment"

python3_installation
systemd_setup
app_restart
#calling app_restart function from common.sh
