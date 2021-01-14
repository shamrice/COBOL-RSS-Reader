#!/bin/bash

#
# Last updated: 2021-01-14
#
# If exists, removes any temporary build files as well as the compiled 
# executable, logs and any generated feed data files.
#

echo cleaning up build files....

rm ./crssr
rm *.c
rm *.h
rm *.i
rm *.log
rm ./feeds/*.dat
rm ./feeds/*.dat.*
rm ./feeds/*.rss

echo done.




