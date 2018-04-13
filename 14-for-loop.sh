#!/bin/bash

for var in gcc zlib httpd java ; do 
    yum install $var -y
done