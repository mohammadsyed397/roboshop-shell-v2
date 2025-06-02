#!/bin/bash

USERID=$(id -u)
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NOCOLOR="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d ":" -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

# Create log folder
mkdir -p $LOGS_FOLDER
echo "Script started executing: $(date)" | tee -a $LOG_FILE

is_user_root(){
    if [ $USERID -ne 0 ]
then
    echo -e "$RED ERROR:: Please run this script with root access $NOCOLOR" | tee -a $LOG_FILE
    exit 1
else
    echo "You are running with root access"  | tee -a $LOG_FILE
fi
}

VALIDATE(){
    if [ $? -eq 0 ]
    then
        echo -e "$2 is ... $GREEN SUCCESS $NOCOLOR"  | tee -a $LOG_FILE
    else
        echo -e "$2 is ...$RED FAILURE $NOCOLOR"  | tee -a $LOG_FILE
        exit 1
    fi
}
system_user_setup(){
    id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]
then 
	useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
	VALIDATE $? "Created a user"
else
	echo "user already exist.."
fi
}
nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disable nodejs module"
dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enable nodejs.20 module"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Install nodejs"
}
app_setup(){
    mkdir -p /app &>>$LOG_FILE
VALIDATE $? "created app folder"
rm -rf /app/* &>>$LOG_FILE
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/$App_name-v3.zip &>>$LOG_FILE
cd /app 
unzip /tmp/$App_name.zip &>>$LOG_FILE
VALIDATE $?  "Download and unzip the code"

}
system_setup(){
    cp $SCRIPT_DIR/services/$App_name.service /etc/systemd/system/$App_name.service &>>$LOG_FILE
VALIDATE $? "Create the custom service for $App_name service"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "daemon reload"

systemctl enable $App_name
systemctl start $App_name &>> $LOG_FILE
}
print_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME))
    echo -e "Script execution completed successfully, $YELLOW time taken: $TOTAL_TIME seconds $NOCOLOR" | tee -a $LOG_FILE
}