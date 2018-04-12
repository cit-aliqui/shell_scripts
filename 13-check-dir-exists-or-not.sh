#!/bin/bash

read -p 'Enter directory: ' DIR 

if [ -d "$DIR" ]; then 
    echo Directory Exists 
else
    echo Directory Not Exists 
fi
