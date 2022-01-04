#!/bin/bash

PS3="please choose: " 



select choice in 'create Database' 'List Database' 'Conncet to Database' 'Drop Database' 'Exit!'
do
case $REPLY in
1 ) . ./createdb.sh
;;
2 ) . ./listdb.sh
;;
3 ) . ./connectdb.sh
;;
4 ) . ./dropdb.sh
;;
5 ) echo 'hope to see you soon'
    echo "Bye!"
    exit
;;
* ) echo "invalid choice, pick again please"
;;
esac
done
