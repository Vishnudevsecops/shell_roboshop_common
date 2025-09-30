#!/bin/bash
# -------------------------
# Color Codes
# -------------------------
R="\e[31m" #Red
G="\e[32m" #Green
Y="\e[33m" #Yellow
N="\e[0m"  #No Color    

#check if current user has root access
user_rootaccess=$(id -u)

mongodb_host="mongodb.techup.fun"
script_dir=$(pwd)
#create folder in log folder 
logs_folder="/var/log/shell-roboshop"
#removing .sh from script name to create a log file
script_name=$( echo $0 | cut -d "." -f1 )
log_file="$logs_folder/$script_name.log" 

echo "script started excuting at : $(date)" | tee -a $log_file

mkdir -p $logs_folder

#if user does not have root access

cehck_rootaccess(){
    if [ $user_rootaccess -ne 0 ]; then 
        echo "Error:: Please run the script using root access"
        exit 1
    fi
    }
# Function to validate installation status
validate(){
    if [ $1 -ne 0 ]; then
        echo -e "error:: $2 $R failed $N" | tee -a $log_file
        exit 1
    else
        echo -e "$2 $G Completed $N" | tee -a $log_file
    fi

}

nodejs_installation(){
    dnf module disable nodejs -y &>>$log_file
    validate $? "Nodejs module disable"
    dnf module enable nodejs:20 -y &>>$log_file
    validate $? "Nodejs module enable"
    dnf install nodejs -y &>>$log_file
    validate $? "Nodejs"

    cd /app || { echo "Failed to change to /app"; exit 1; }
    npm install &>>$log_file
    validate $? "npm dependencies"
}

app_setup(){

    mkdir -p /app &>>$log_file
    validate $? "/app directory creation"

    #download catalogue code
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
    validate $? "$app_name download"
    cd /app
    validate $? "changing directory to /app"

    #remove old content
    rm -rf /app/* &>>$log_file
    validate $? "removing old content"

    #unzip the content
    unzip /tmp/$app_name.zip &>>$log_file
    validate $? "$app_name unzip"
    }

    systemd_setup(){
        #copy service file
    cp $script_dir/$app_name.service /etc/systemd/system/$app_name.service &>>$log_file
    validate $? "$app_name service file copy"

    systemctl daemon-reload &>>$log_file
    validate $? "daemon reload"
    systemctl enable $app_name &>>$log_file
    validate $? "$app_name enable"
    systemctl start $app_name &>>$log_file
    validate $? "$app_name start"   
    }

    app_restart(){
        systemctl restart $app_name &>>$log_file
        validate $? "$app_name restart"
    }

    maven_installation(){
        dnf install maven -y &>>$log_file
        validate $? "Maven installation"
        cd /app 
        mvn clean package 
        mv target/shipping-1.0.jar shipping.jar
    }

    python3_installation(){
        dnf install python3 gcc python3-devel -y &>>$log_file
        validate $? "Python3 installation"
        cd /app || { echo "Failed to change to /app"; exit 1; }
        pip3 install -r requirements.txt &>>$log_file
        validate $? "Python dependencies"
    }
