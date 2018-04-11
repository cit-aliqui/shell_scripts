#!/bin/bash

read -p 'Enter Stack Name [DB|APP|WEB]: ' inp

## Always use double quotes while accessing variables in expressions
## Especially while accessing string comparisions always access variables with double quotes


## Multi Line Comments
<<EOF  
if [ $inp = DB ]; then 
    echo "DB Setup"
fi

if [ $inp = WEB ]; then 
    echo "WEB Setup"
fi 

if [ $inp = APP ]; then 
    echo "APP Setup"
fi
EOF
###

if [ "$inp" = DB ]; then 
    echo "DB Setup"
elif [ "$inp" = WEB ]; then 
    echo "WEB Setup"
elif [ "$inp" = APP ]; then 
    echo "APP Setup"
else
    echo "Wrong Input!! Try Again .. "
fi

