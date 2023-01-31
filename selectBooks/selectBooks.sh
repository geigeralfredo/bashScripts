#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: selectBooks.sh
#Purpose: Select the books you want, supplying the following
#         non-positional parameters:
#
#           -c  diretory with book collection (mandatory)
#           -l  directory to write book lists
#           -s  file containing subjects (mandatory)
#---------------------------------------------------------------------
#function definition concatGrep ()
# Concatenate grep + pipes + file writing commands conditioned by 
# the number of occurrences of the file of subjects
#---------------------------------------------------------------------

concatGrep ()
{
#-----------------------------------------
# variables and constants definitions
#-----------------------------------------
cat="cat "
pathPlusFile="$PATH_PLUS_FILENAME"
command=""
outfile="  > /tmp/temporary.txt"
grepi=" grep -i "
grepiv=" grep -iv "
grepiw=" grep -iw "
grepEiStart="grep -Ei '(^|[^a-z])"
grepEiEnd="([^a-z]|$)'"
pipe=" | "

arraySize=${#array[@]}

limit=${arraySize}
((limit--))

for (( i=0; i<${arraySize}; i++ ))
    do
        if  [ ${array[i]:0:1} = . ]                 # 1st char = "."
        then
            command+=$grepiv${array[i]}
        else
            if [ ${array[i]:0:1} = ! ]              # 1st char = "!"
            then                
                if [ ${array[i]:1:1} = . ]          # 2nd char = "."
                then
                    work=${array[i]/./}
                    command+=$grepiv$work
                else
                    work=${array[i]/!/}
                    command+=$grepEiStart$work$grepEiEnd
                fi
            else
                command+=$grepi${array[i]}
            fi
        fi
            
        if [ $i -eq ${limit} ]
        then                
                command+=$outfile                
        else
                command+=$pipe
        fi
    done
        
        command=$cat$pathPlusFile$pipe$command
}

#---------------------------------------------------------------------
#function definition realWork ()
#---------------------------------------------------------------------

realWork ()
{    
    #While loop to read line by line
    while read -r line
    do    
        array=( $line )

#        echo "1st occurrence = " "${array[0]}"
#        echo "2nd occurrence = " "${array[1]}"                   
        
        concatGrep
        
        eval $command
        
        #Inserting double quotes at the beginning and at the end of the string
        sed "s/.*/\"&\"/" /tmp/temporary.txt >  /tmp/temporary2.txt

        # Construct $filename using 
        # $DirName ${array[@]} $Suffix $Extension
        DirName="$DIR_BOOK_LISTS"
        Suffix=".list"
        Extension=".txt"
        MiddleName=""
        
        # construct filename for the Totals
        Totals="selectedBooksTotals.txt"
        fileTotals=$DirName$Totals
        
        #   Construct the MiddleName variable
        for (( i=0; i<${arraySize}; i++ ))
            do
                MiddleName+=${array[i]}
            done
                
        FileName=$DirName$MiddleName$Suffix$Extension
        
        # Display array size
        echo "ArraySize = " "${arraySize}" >> $fileTotals
        
        # display the words in array
        for (( i=0; i<${arraySize}; i++ ))
            do
                echo "Occurrence #" $i " = " "${array[i]}" >> $fileTotals
            done

        # display FileName
        echo "FileName = " "$FileName" >> $fileTotals
        
        # sorting the file and put it in $FileName
        sort /tmp/temporary2.txt > "$FileName" 
       
       # display books found total
        echo "============================================================" >> $fileTotals
        wc -l "$FileName" | awk '{ print "Number of Books found = " $1 }'   >> $fileTotals
        echo "============================================================" >> $fileTotals

        # remove temp files
        rm /tmp/temporary.txt
        rm /tmp/temporary2.txt
    
    done < "$SUBJECTS_FILE" 
    
}

#--------------------------------------------------------------------
# Begining of the SCRIPT
# Definition of error codes

E_SUBJETCS_FILE_DO_NOT_EXIST_ERR=10
E_DIR_BOOK_COLLECTION_ERR=20
E_DIR_BOOK_LISTS_ERR=30
E_SUBJECTS_FILE_ERR=40
E_MORE_THAN_6_WORDS_ERR=50
SUCCESS=0

#--------------------------------------------------------------------
# Set variables for each arg.
# c -> Collection of books
# l -> Lists of books
# s -> Subjects file
#---------------------------------------------------------------------
while getopts c:l:s: option
do
    case "${option}"
    in        
        c) DIR_BOOK_COLLECTION=${OPTARG};;
        l) DIR_BOOK_LISTS=${OPTARG};;
        s) SUBJECTS_FILE=${OPTARG};;
    esac
done

#--------------------------------------------------------------------
#verifying arg $DIR_BOOK_COLLECTION
if [ -z "$DIR_BOOK_COLLECTION"  ]; then 
    echo "Name of the directory to be searched is mandatory"
    echo "script will terminate"
    exit $E_DIR_BOOK_COLLECTION_ERR
fi

#--------------------------------------------------------------------
#verifying arg $DIR_BOOK_LISTS
if [ -z "$DIR_BOOK_LISTS"  ]; then 
    echo "Name of the directory to write the books found is mandatory"
    echo "script will terminate"
    exit $E_DIR_BOOK_LISTS_ERR
fi

#--------------------------------------------------------------------
#verifying arg of subjects file
if [ -z "$SUBJECTS_FILE" ]; then 
    echo "Name of the file containing subject strings is mandatory"
    echo "script will terminate"
    exit $E_SUBJECTS_FILE_ERR
fi

#--------------------------------------------------------------------
# check the existence of directories
if [ ! -d "$DIR_BOOK_COLLECTION" ] 
then
   echo "Directory $DIR_BOOK_COLLECTION does not exist."
   echo "Script will terminate"   
   exit $E_DIR_BOOK_COLLECTION_ERR
fi

#--------------------------------------------------------------------
# check the existence of directories
if [ ! -d "$DIR_BOOK_LISTS" ] 
then
   echo "Directory $DIR_BOOK_LISTS does not exist."
   echo "Script will terminate"   
   exit $E_DIR_BOOK_LISTS_ERR
fi

#--------------------------------------------------------------------
# check the existence of the file with subjects
if [ ! -f "$SUBJECTS_FILE" ] 
then
   echo "File with parameters ($SUBJECTS_FILE) does not exist."
   echo "Script will terminate"   
   exit $E_SUBJETCS_FILE_DO_NOT_EXIST_ERR
fi

#--------------------------------------------------------------------

    # remove all files from $DIR_BOOK_LISTS
    cd $DIR_BOOK_LISTS
    rm *list.txt
    rm selectedBooksTotals.txt
    cd

# check the existence of the file with all the books
# if does not exist create it
    ALL_BOOKS_TXT="AllBooks.txt"
    PATH_PLUS_FILENAME=$DIR_BOOK_LISTS$ALL_BOOKS_TXT     # construct the filename with its path 
    
    # check the existence of the file with subjects
    if [ ! -f "$PATH_PLUS_FILENAME" ] 
    then
        find "$DIR_BOOK_COLLECTION" -iname '*' -type f -print > "/tmp/temporary3.txt"
        sort "/tmp/temporary3.txt" > "$PATH_PLUS_FILENAME"
        rm /tmp/temporary3.txt
    fi

#--------------------------------------------------------------------
# Calls "realWork" passing:
#   $SUBJECTS_FILE      -> file with subjects
#   $PATH_PLUS_FILENAME -> filename with all books
#   $DIR_BOOK_LISTS     -> File to put the list of books found

realWork $SUBJECTS_FILE  $PATH_PLUS_FILENAME  $DIR_BOOK_LISTS

wc -l "$PATH_PLUS_FILENAME" | awk '{ print "# of books in Library = " $1 }'     >> $fileTotals
echo "============================================================"             >> $fileTotals

#--------------------------------------------------------------------
exit $SUCCESS
