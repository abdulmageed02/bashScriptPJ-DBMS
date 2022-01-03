#!/bin/bash

if [  -d databases ]
then 
 ls databases
else
 echo "no databases to be shown"
fi

sleep 1.5

. ./maindb.sh