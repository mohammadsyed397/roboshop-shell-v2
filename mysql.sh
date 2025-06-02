#!/bin/bash
$App_name
source ./common.sh $App_name
is_user_root
dnf install mysql-server -y &>>$LOG_FILE
 VALIDATE $? "Installing mysql server"

 systemctl enable mysqld
 systemctl start mysqld  &>>$LOG_FILE
 VALIDATE $? "Enable mysql server"

 mysql_secure_installation --set-root-pass syed@123 &>>$LOG_FILE
 VALIDATE $? "changing the default password"
 print_time