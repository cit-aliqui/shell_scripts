#!/bin/bash

## Print content using echo command

echo Hello

## To print multiple line

echo      # To print empty line
echo Hello
echo World

## Enable esacape sequences
    # \n - New Line
    # \t - New Tab
    # \e - Enable Color
# Always use double quotes in the inputs of echo command

echo -e "\nHello\nWorld"

## Print some colors 
## R Red , G Green, Y Yellow, B Blue, M Magenta, C Cyan
## Foreground Backgroud
## 31 41, 32 42, 33 43, 34 44, 35 45, 36 46

echo -e "\e[31mHello World\e[0m"
echo Good Morning
