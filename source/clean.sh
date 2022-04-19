#!/bin/bash

#
# Last updated: 2022-04-19
#
# If exists, removes any temporary build files as well as the compiled 
# executable, logs, config and any generated feed data files.
#

echo cleaning up build files....

rm ./crssr
rm ./crssr.conf 
rm *.c
rm *.h
rm *.i
rm *.log
rm ./feeds/*.dat
rm ./feeds/*.dat.*
rm ./feeds/*.rss

echo done.




