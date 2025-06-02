#!/bin/bash
$App_name=payment
source ./common.sh $App_name
is_user_root
system_user_setup
app_setup
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "Installing Python3"
pip3 install -r requirements.txt &>>$LOG_FILE
VALIDATE $? "Installing requirements"
system_setup
print_time
