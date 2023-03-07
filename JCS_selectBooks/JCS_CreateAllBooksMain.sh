#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_CreateAllBooksFile.sh (JCS = Job Control Script)
#Purpose: Creation of AllBooks file
#
#Parameters: 1) Diretory with the book collection (mandatory)
#            2) Directory where to write the AllBooks file (also mandatory)
#---------------------------------------------------------------------

#Constants
ALL_BOOKS_TXT="AllBooks.txt"
SUCCESS=0

# check number of arguments, must be 2 arguments
if [[ $# -lt 2 ]]
  then
    echo "JCS_CreateAllBooksFile.sh - Two arguments must be informed:"
    echo "JCS_CreateAllBooksFile.sh - - 1) The book collection Diretory, plus"
    echo "JCS_CreateAllBooksFile.sh - - 2) The directory to write AllBooks file."
    echo "JCS_CreateAllBooksFile.sh - Script will terminate."
    exit 1
fi

# Saving arguments
DIR_BOOK_COLLECTION=$1
DIR_ALL_BOOKS=$2

# Verifying arguments
if [ ! -d $DIR_BOOK_COLLECTION ]; then
  echo "JCS_CreateAllBooksFile.sh - Directory $DIR_BOOK_COLLECTION does not exist."
  echo "JCS_CreateAllBooksFile.sh - the script will terminate."
  exit 1
fi

if [ ! -d $DIR_ALL_BOOKS ]; then
  echo "JCS_CreateAllBooksFile.sh - Directory $DIR_ALL_BOOKS does not exist."
  echo "JCS_CreateAllBooksFile.sh - it will be created."
  mkdir $DIR_ALL_BOOKS
fi

ALL_BOOKS_PATH_PLUS_FILENAME=$DIR_ALL_BOOKS$ALL_BOOKS_TXT

# Here arguments are OK
echo "*---------------------------------------------------------------------*"
echo "DIR_BOOK_COLLECTION            = " $DIR_BOOK_COLLECTION
echo "ALL_BOOKS_PATH_PLUS_FILENAME   = " $ALL_BOOKS_PATH_PLUS_FILENAME
echo "*---------------------------------------------------------------------*"

# check the existence of the file with all the books
# if it exists go away, create it otherwise
if [ ! -f $ALL_BOOKS_PATH_PLUS_FILENAME ] 
then
    find "$DIR_BOOK_COLLECTION" -iname '*' -type f -print > "/tmp/AllBooks.txt"
    sort "/tmp/AllBooks.txt" > $ALL_BOOKS_PATH_PLUS_FILENAME
    rm "/tmp/AllBooks.txt"
fi

#--------------------------------------------------------------------
