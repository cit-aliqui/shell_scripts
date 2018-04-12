#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
HE="\e[36;4m"

LOG=/tmp/stack.log 
rm -f /tmp/stack.log

headf() {
    echo -e "\t>> ${HE}${1}${N}"
}

success() {
    echo -e "-> ${G}${1}${N} - SUCCESS"
}

error() {
    echo -e "-> ${R}${1}${N} - FAILED"
    echo -e "\t Check log file : $LOG"
}

Stat() {
    if [ $1 -eq 0 ]; then 
        success "$2"
    else
        error "$2"
    fi 
}

DBF() {
###
headf "DB SERVER SETUP"
yum install mariadb-server -y &>>$LOG 
Stat $? "Installing MariaDB"

systemctl startx mariadb &>>$LOG 
Stat $? "Starting MariaDB"

}

APPF() {
###
echo "APP SERVER SETUP"
}

WEBF() {
###
echo "WEB SERVER SETUP"
}


#### Main Program 

# Check root user
if [ $(id -u) -ne 0 ]; then 
    echo "You should run this script as root user or sudo script"
    exit 1
fi

if [ -z "$1" ]; then 
    read -p $'Enter Stack name to Setup [DB|WEB|APP|\e[33mALL\e[0m]: ' inp
else
    inp=$1
fi 

if [ -z "$inp" ]; then 
    inp=ALL 
fi 

case $inp in 
    DB) 
        DBF;;
    APP) 
        APPF ;;
    WEB) 
        WEBF ;;
    ALL) 
        DBF
        APPF 
        WEBF 
        ;;
    *) 
        echo "Wrong Input, Try again ..."
        exit 1
        ;;
esac
