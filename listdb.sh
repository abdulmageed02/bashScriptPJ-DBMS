#!/bin/bash

if [  -d databases ]
then 
 ls databases 2>/dev/null
else
 echo "no databases to be shown"
fi

           select c in "go back to main menu" "exit"
            do
            case $REPLY in
            1 ) . ./maindb.sh ;;
            2 ) exit ;;
            esac
            done

