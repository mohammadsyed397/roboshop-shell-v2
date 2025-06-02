#!/bin/bash
$App_name=dispatch

source ./common.sh $App_name
is_user_root
system_user_setup
app_setup
dnf install golang -y &>>$LOG_FILE
VALIDATE $? "Installing GoLang"
go mod init dispatch &>>$LOG_FILE
VALIDATE $? "initializing go module"

go get &>>$LOG_FILE
VALIDATE $? "Downloading dependencies"

go build &>>$LOG_FILE
VALIDATE $? "Installing dependencies"
system_setup
print_time
