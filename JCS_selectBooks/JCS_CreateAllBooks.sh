#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_CreateAllBooks.sh (JCS = Job Control Script)
#
#Purpose:   Reads the file with the arguments that will be passed to
#           JCS_CreateAllBooksMain.sh script
#
#Parameters: 1) Diretory with the book collection (mandatory)
#            2) Directory where to write the AllBooks file (also mandatory)
#---------------------------------------------------------------------
mapfile -t < ~/sh_JCS/JCS_CreateAllBooksArguments.txt
source JCS_CreateAllBooksMain.sh "${MAPFILE[@]}"
