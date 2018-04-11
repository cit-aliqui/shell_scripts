#!/bin/bash

read -p 'Enter Stack [DB|APP|WEB]: ' inp

case $inp in
    DB)
        echo "DB SERVER SETUP"
        ;;
    APP)
        echo "APP SERVER SETUP"
        ;;
    WEB)
        echo "WEB SERVER SETUP"
        ;;
    *) 
        echo -e "\e[31mWrong Input, Try any one of DB|APP|WEB\e[0m"
        exit 1
        ;;
esac
