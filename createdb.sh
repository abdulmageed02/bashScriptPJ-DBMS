#!/bin/bash



while [ true ]
do
echo "Please enter characters only "

read name              
if [[ $name =~ ^[a-z|A-Z]+$  ]];
	then 
    while [ true ]
    do 
        if [ -d ./databases/$name ] ;
         then
            echo "$name exists."
            continue 2;
        else 
            mkdir -p databases/$name   
            echo "$name database created"
          
            select c in "create new database " "go back to main menu"
            do
            case $REPLY in
            1 ) . ./createdb.sh  ;;
            2 ) . ./maindb.sh  ;;
            esac
            done
            
        fi
        done
	break ;
fi
done


