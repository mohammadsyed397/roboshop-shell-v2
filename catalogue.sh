#!/bin/bash

App_name=catalogue
source ./common.sh
is_user_root
nodejs_setup
system_user_setup
app_setup
system_setup
cp $SCRIPT_DIR/repos/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.robosyed.space --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.robosyed.space </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Copying the data to MongoDB Database"
else
    echo -e "Data is already loaded ... $YELLOW SKIPPING $NOCOLOR"
fi
print_time