#!/bin/bash
$App_name=shipping
source ./common.sh $App_name
is_user_root
system_user_setup
app_setup
echo "Enter root password"
read -s MYSQL_ROOT_PASSWORD
dnf install maven -y &>>$LOG_FILE
VALIDATE $? "Installing Maven"
mvn clean package &>>$LOG_FILE
VALIDATE $? "Packaging the $App_name code"

mv target/$App_name-1.0.jar $App_name.jar 
VALIDATE $? "Renaming $App_name jar"
system_setup

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing MySql" 

mysql -h mongodb.robosyed.space -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql &>>$LOG_FILE
mysql -h mongodb.robosyed.space -uroot -p$MYSQL_ROOT_PASSWORD< /app/db/app-user.sql &>>$LOG_FILE
mysql -h mongodb.robosyed.space -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>>$LOG_FILE
VALIDATE $? "Loading data to MySql" 

systemctl restart $App_name &>>$LOG_FILE
VALIDATE $? "Restarting $App_name service"


