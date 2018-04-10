#!/bin/bash

## Parsed inputs can be accessed inside the script using Special Variables

## $0 to $9 , $*, $@, $# , $$

echo '$0 =' $0   # $0 is script name
echo '$1 =' $1   # First argument you parsed to script, Ex: ./script 10 .... Now 10 is $1 

echo '$10 = ' ${10} # 10th value, {} are used to bind a value together


echo '$* =' $*  # All the values which are parsed
echo '$@ =' $@  # All the values which are parsed

echo '$# =' $#  # Number of values which are parsed

echo '$$ =' $$ # PID of script