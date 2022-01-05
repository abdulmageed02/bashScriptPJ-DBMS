#!/bin/bash

while [ true ]; do
    echo "enter the table name "
    read name

    while [ true ]; do
        FILE=./databases/$1/$name
        if [ -f $FILE ]; then

            while true; do
                echo "Please enter Colname "
                read coln

                FIELDN=$(awk 'BEGIN{FS="|"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$name)

                if [[ -z $(awk 'BEGIN{FS="|"}{if ($1=="'$coln'")print $1}' ./databases/$1/.$name) ]]; then
                    echo 'invalid column name'
                    select choice in 'Select new Column ?' 'go back to table menu'; do
                        case $REPLY in
                        1) break ;;
                        2) . ./connectdb.sh $1 ;;
                        *) echo " invalid choice, pick again please" ;;
                        esac
                    done

                    break
                else
                    while true; do
                        echo "select column value requird "
                        read colv
                        while [[ -z $colv ]]; do
                            echo "you cant search with null value, select col value requird "
                            read colv
                        done

                        if [[ ! -z $(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'") print $0}' ./databases/$1/$name) ]]; then

                            awk 'BEGIN{FS="|"}{ if(NR==1) {print $0}}' ./databases/$1/$name | column -t -s '|'
                            awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print $0;exit}}' ./databases/$1/$name | column -t -s '|'

                            select choice in 'Select new record?' 'go back to table menu'; do
                                case $REPLY in
                                1) . ./selectrec.sh $1 ;;
                                2) . ./connectdb.sh $1 ;;
                                *) echo " invalid choice, pick again please" ;;
                                esac
                            done
                        else
                            echo "not match with $colv"
                            select choice in 'Enter new column value ?' 'go back to table menu'; do
                                case $REPLY in
                                1) break ;;
                                2) . ./connectdb.sh $1 ;;
                                *) echo " invalid choice, pick again please" ;;
                                esac
                            done
                        fi
                    done
                fi
            done

        else
            echo "this table doesnt exist"
            select choice in 'Select new table ?' 'go back to table menu'; do
                case $REPLY in
                1) break ;;
                2) . ./connectdb.sh $1 ;;
                *) echo " invalid choice, pick again please" ;;
                esac
            done
            break
        fi
    done
done
