#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_CreateAllBooksMain.sh (JCS = Job Control Script)
#Purpose: Creation of AllBooks file
#
#Parameters: 1) Diretory with the book collection (mandatory)
#            2) Directory where to write the AllBooks file (also mandatory)
#            3) Literals: [create=yes] or [create=no]
#
#   OBS: All parameters were already checked in script JCS_CreateAllBooks.sh
#---------------------------------------------------------------------

############################################################################
#             Helper Constants
############################################################################
scriptName="JCS_CreateAllBooksMain.sh"
ALL_BOOKS_TXT="AllBooks.txt"

# Saving arguments
DIR_BOOK_COLLECTION=$1
DIR_ALL_BOOKS=$2
CREATE_YES_NO=$3

# Received parameters
echo "$scriptName - DIR_BOOK_COLLECTION = " "$DIR_BOOK_COLLECTION"
echo "$scriptName - DIR_ALL_BOOKS       = " "$DIR_ALL_BOOKS"
echo "$scriptName - CREATE_YES_NO       = " "$CREATE_YES_NO"

ALL_BOOKS_PATH_PLUS_FILENAME=$DIR_ALL_BOOKS$ALL_BOOKS_TXT

# Here arguments are OK
echo "$scriptName - *---------------------------------------------------------------------*"
echo "$scriptName - DIR_BOOK_COLLECTION            = " "$DIR_BOOK_COLLECTION"
echo "$scriptName - ALL_BOOKS_PATH_PLUS_FILENAME   = " "$ALL_BOOKS_PATH_PLUS_FILENAME"
echo "$scriptName - *---------------------------------------------------------------------*"

# Creates the file if "create=yes"
if [ "$CREATE_YES_NO" == "create=yes" ]; then
    echo "$scriptName - All Books file will be created." 
    find "$DIR_BOOK_COLLECTION" -iname '*' -type f -print > "/tmp/AllBooks.txt"
    sort "/tmp/AllBooks.txt" > "$ALL_BOOKS_PATH_PLUS_FILENAME"
    rm "/tmp/AllBooks.txt"
else
    echo "$scriptName - ============================================="
    echo "$scriptName - As asked, All Books file WILL NOT be created."
    echo "$scriptName - ============================================="
fi

#--------------------------------------------------------------------
