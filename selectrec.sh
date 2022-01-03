#!/bin/bash

while [ true ]
do
echo "enter the table name "
read name 

    while [ true ]
    do 
    FILE=./databases/$1/$name
        if [ -f $FILE ];
         then
         
                while true
                do
                echo "Please enter Colname " # Ask for col name hna , after it use awk to check on first record col name if there is a match move on if not ask for anew col name 
                read  coln  
               # colv=""
               # colv=$(awk 'BEGIN{FS="|"}{if ($1=="'$coln'")print $1}' ./databases/$1/.$name)
               FIELDN=$(awk 'BEGIN{FS="|"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$name)
               #echo $FIELDN
                    if [[ -z $(awk 'BEGIN{FS="|"}{if ($1=="'$coln'")print $1}' ./databases/$1/.$name) ]];then
                    echo 'invalid col name'
                    break;
                    else
                        while true 
                        do
                        echo "select col value requird "
                        read colv
                       # v=""
                        #v=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$value'") print $0}' ./databases/$1/$name)
                        if [[ ! -z $(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'") print $0}' ./databases/$1/$name) ]];then
                            
                            awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print $0;exit}}' ./databases/$1/$name
                            
                            select choice in 'Select new record?' 'go back to table menu' 'Delete Record' 'Update Record'
                            do
                            case $REPLY in 
                            1 ) . ./selectrec.sh $1 ;;
                            2 ) . ./connectdb.sh $1 ;;
                            3 ) RECORDN=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print NR}}' ./databases/$1/$name)
                                sed -i "$RECORDN"d ./databases/$1/$name
                                    . ./connectdb.sh $1
                                                ;;
                            4 )  echo -e "insert new value for the current col value: "
                                read NewV
                                RECORDN=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print NR}}' ./databases/$1/$name)
                                OldV=$(awk 'BEGIN{FS="|"}{if(NR=='$RECORDN'){for(i=1;i<=NF;i++){if(i=='$FIELDN') print $i}}}'   ./databases/$1/$name)
                                echo $oldValue
                                sed -i ''$RECORDN's/'$OldV'/'$NewV'/g' ./databases/$1/$name
                                echo "Row Updated Successfully"
                                 . ./connectdb.sh $1
                                ;;
                            * )     echo " invalid choice, pick again please" ;;
                             esac
                             done
                        else
                        echo "not match with $colv"
                        fi
                        done
                    fi
                done
        
        else
        echo "this table doesnt exist"
        break;
        fi
    done
done