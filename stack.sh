#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
HE="\e[36;4m"

LOG=/tmp/stack.log 
rm -f /tmp/stack.log

TOM_URL=$(curl -s https://tomcat.apache.org/download-90.cgi | grep Core -A 20 | grep tar.gz | grep nofollow | cut -d ' ' -f2 | cut -d '"' -f2)
TOM_DIR=$(echo $TOM_URL | awk -F / '{print $NF}' | sed 's/.tar.gz//')
WAR_URL='https://github.com/cit-aliqui/APP-STACK/raw/master/student.war'
JDBC_URL='https://github.com/cit-aliqui/APP-STACK/raw/master/mysql-connector-java-5.1.40.jar'
CONN_URL='http://www-us.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.43-src.tar.gz'
CONN_DIR=$(echo $CONN_URL | awk -F / '{print $NF}' | sed -e 's/.tar.gz//')
RESOURCE='<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxActive="50" maxIdle="30" maxWait="10000"  username="student" password="student@1" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://MYSQL-DB_SERVER:3306/studentapp"/>'
IPADDRESS=$(hostname -i)


headf() {
    echo -e "\t>> ${HE}${1}${N}"
}

success() {
    echo -e "-> ${G}${1} - SUCCESS${N}"
}

skip() {
    echo -e "-> ${Y}${1} - SKIPPING${N}"
}

error() {
    echo -e "-> ${R}${1} - FAILED${N}"
    echo -e "\t Check log file : $LOG"
}

Stat() {
    if [ $1 = SKIP ]; then 
        skip "$2"
        return
    fi 
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

    systemctl start mariadb &>>$LOG 
    Stat $? "Starting MariaDB"
    systemctl enable mariadb &>/dev/null 

    echo "create database if not exists studentapp;
    use studentapp;
    CREATE TABLE if not exists Students(student_id INT NOT NULL AUTO_INCREMENT,
        student_name VARCHAR(100) NOT NULL,
        student_addr VARCHAR(100) NOT NULL,
        student_age VARCHAR(3) NOT NULL,
        student_qual VARCHAR(20) NOT NULL,
        student_percent VARCHAR(10) NOT NULL,
        student_year_passed VARCHAR(10) NOT NULL,
        PRIMARY KEY (student_id)
    );
    grant all privileges on studentapp.* to 'student'@'%' identified by 'student@1';
    flush privileges;" >/tmp/student.sql 

    mysql </tmp/student.sql  &>>$LOG 
    Stat $? "Configuring DB Schema"

}

APPF() {
###
    headf "APP SERVER SETUP"
    yum install java -y &>>$LOG 
    Stat $? "Installing Java"
    cd /root

    if [ -d "$TOM_DIR" ]; then 
        Stat SKIP "Downloading Tomcat"
    else
        wget -q -O- $TOM_URL | tar -xz
        Stat $? "Downloading Tomcat"
    fi

    cd $TOM_DIR 
    rm -rf webapps/* 

    wget -q $WAR_URL -O webapps/student.war &>>$LOG 
    Stat $? "Downloading WAR File"
    wget -q $JDBC_URL -O lib/mysql-connector-java-5.1.40.jar &>>$LOG
    Stat $? "Downloading JDBC JAR File"
    sed -i -e '/TestDB/ d' -e "$ i $RESOURCE" conf/context.xml 
    sed -i -e "s/MYSQL-DB_SERVER/$IPADDRESS/" conf/context.xml 

    ps -ef | grep java | grep -v grep &>/dev/null 
    if [ $? -eq 0 ]; then 
        sh bin/shutdown.sh &>>$LOG 
        Stat $? "Shutdown Tomcat"
        sleep 5 
    fi 
    sh bin/startup.sh &>>$LOG 
    Stat $? "Starting Tomcat"
}

WEBF() {
    ###
    headf "WEB SERVER SETUP"
    yum install httpd httpd-devel gcc -y &>>$LOG 
    Stat $? "Installing Web Server"
    cd /root 
    if [ -f "/etc/httpd/modules/mod_jk.so" ]; then 
        Stat SKIP "Installing Tomcat Connector"
    else 
        wget -q -O- $CONN_URL | tar -xz
        Stat $? "Downlading Tomcat Connector"
        cd /root/$CONN_DIR/native 
        ./configure --with-apxs=/usr/bin/apxs &>>$LOG 
        make &>>$LOG 
        make install &>>$LOG 
        Stat $? "Installing Tomcat Connector"
    fi 
    echo 'LoadModule jk_module modules/mod_jk.so

JkWorkersFile conf.d/worker.properties
JkMount /student local
JkMount /student/* local' >/etc/httpd/conf.d/mod-jk.conf 

    echo 'worker.list=local
worker.local.host=localhost
worker.local.port=8009' > /etc/httpd/conf.d/worker.properties 

    systemctl enable httpd &>/dev/null 
    systemctl restart httpd &>>$LOG 
    Stat $? "Starting Web Server"
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
