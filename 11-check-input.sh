#!/bin/bash

val=$1
if [ -z "$val" ]; then 
    read -p 'Enter val: ' val
fi

if [ -z "$val" ]; then  ## This expression will be true if $val is empty
    echo "Empty Value"
else
    echo "Not Empty"
fi

