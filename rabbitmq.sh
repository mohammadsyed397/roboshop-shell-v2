#!/bin/bash
$App_name=rabbitmq
source ./common.sh $App_name
is_user_root
cp repos/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabitmq"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
VALIDATE $? "creating user for rabbitmq"
print_time
