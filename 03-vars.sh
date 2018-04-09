#!/bin/bash

a=10
echo "Val of a = $a"

## Why do we use variables. -> If you use the same value again and again , then use variables

DATE=2018-04-20
echo "Today date is $DATE"
echo "On $DATE day is Monday"
echo "On $DATE Class is DevOps"

## What if you need variable dynamically.
## Command Substution 

DATE=$(date +%F)  ## DATE=`date +%F`
echo -e "\nToday date is $DATE"

## Arithematic Substition
ADD=$((1+2))
