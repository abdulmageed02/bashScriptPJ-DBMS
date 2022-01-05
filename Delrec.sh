while [ true ]; do
    echo "enter the table name "
    read name

    while [ true ]; do
        FILE=./databases/$1/$name
        if [ -f $FILE ]; then

            while true; do
                echo "Please enter Colname " # Ask for col name hna , after it use awk to check on first record col name if there is a match move on if not ask for anew col name
                read coln
                # colv=""
                # colv=$(awk 'BEGIN{FS="|"}{if ($1=="'$coln'")print $1}' ./databases/$1/.$name)
                FIELDN=$(awk 'BEGIN{FS="|"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$name)
                #echo $FIELDN
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
                        # v=""
                        #v=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$value'") print $0}' ./databases/$1/$name)
                        if [[ ! -z $(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'") print $0}' ./databases/$1/$name) ]]; then

                            awk 'BEGIN{FS="|"}{ if(NR==1) {print $0}}' ./databases/$1/$name | column -t -s '|'
                            awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print $0;exit}}' ./databases/$1/$name | column -t -s '|'

                            select choice in 'Confirm deleting record' 'go back to table menu'; do
                                case $REPLY in
                                1)
                                    RECORDN=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print NR}}' ./databases/$1/$name)
                                    sed -i "$RECORDN"d ./databases/$1/$name
                                    echo " Record Deleted "
                                    . ./connectdb.sh $1
                                    ;;
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
            select choice in 'Delete new table ?' 'Go back to table menu'; do
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
