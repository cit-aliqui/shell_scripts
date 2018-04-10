#!/bin/bash

## Functions

Backup() {
    echo "Backup Started"
    tar -czf backup.tgz $1 &>/dev/null
    echo "Backup Completed"
}

exfunc() {
    echo '$1 in function =' $1
}

## return command of function
example() {
    echo hai
    return 1
    echo bye
}

## Main Program
DIR=$1

echo '$1 in main program=' $1
#exfunc $1
#Backup $DIR

example
echo '$? of function =' $?
