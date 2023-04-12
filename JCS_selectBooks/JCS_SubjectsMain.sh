#!/bin/bash
############################################################################
#SCRIPT: JCS_SubjectsMain.sh
#           Receives all the parameters from script JCS_Subjects.sh
#
#PURPOSE:   To create the Subjects file that will be written in 
#           selectedBooks_SubjectsWithoutPlural.txt 
#           and create the file with the phonetic code for each word in 
#           selectedBooks_EncodedWords.txt
#
#           Called programs:
#
#           - Program wordsOnly:
#
#               - Parameters: (Mandatory)
#                   1-File with a summary of a list of all books
#                   2-Directory base name of the Book collection
#
#               - Generates:
#                   1) selectedBooks_OnlyWords.txt
#                     A file with all words of directory names
#                     and book Titles.
#                   2) selectedBooks_RejectedWords.txt
#                   3) selectedBooks_RejectedByRegExs.txt
#
#           - Sorts the generated file (1) above with the "-u" (unique) 
#             flag to remove the duplicate words
#
#           - Program removePlural:
#
#               - Reads the output of the "sort" program above
#               - Generates files:
#                   1) Subjects file: selectedBooks_SubjectsWithoutPlural.txt
#                   2) WordsWithPlural file: selectedBooks_WordsWithPlural.txt
#
#           - Program Soundex:
#
#               - Reads file selectedBooks_SubjectsWithoutPlural.txt
#               - Generates: 
#                   1) Encoded words file: selectedBooks_EncodedWords.txt
############################################################################
#
# Only arg - File to be read 
#

# check number of arguments, must be 5
if [[ ! $# -lt 6 ]]
  then
    echo "JCS_SubjectsMain.sh - Inform 5 File names:" 
    echo "JCS_SubjectsMain.sh - 1-File with a list of all books"
    echo "JCS_SubjectsMain.sh - 2-Directory base name of the Book collection"
    echo "JCS_SubjectsMain.sh - 3-File that will receive Only Words"
    echo "JCS_SubjectsMain.sh - 4-File that will receive Rejected Words"
    echo "JCS_SubjectsMain.sh - 5-File that will receive Rejected Words By RegExs"
    echo "JCS_SubjectsMain.sh - Script will terminate"
    exit 1
fi

# Saving arguments
file2beRead=$1
dirBaseName=$2
onlyWords=$3
rejectedWords=$4
rejectedWordsByRegExs=$5

# Verifying arguments
if [ ! -f "$file2beRead" ]; then
  echo "JCS_SubjectsMain.sh - File $file2beRead does not exist."
  echo "JCS_SubjectsMain.sh - the script will terminate"  
  exit 1
fi

if [ ! -d "$dirBaseName" ]; then
  echo "JCS_SubjectsMain.sh - File $dirBaseName does not exist."
  echo "JCS_SubjectsMain.sh - the script will terminate"  
  exit 1
fi

if [ ! -f "$onlyWords" ]; then
  echo "JCS_SubjectsMain.sh - File $onlyWords does not exist."
  echo "JCS_SubjectsMain.sh - It will be created"  
  touch "$onlyWords"
fi

if [ ! -f "$rejectedWords" ]; then
  echo "JCS_SubjectsMain.sh - File $rejectedWords does not exist."
  echo "JCS_SubjectsMain.sh - It will be created"  
  touch "$rejectedWords"
fi

if [ ! -f "$rejectedWordsByRegExs" ]; then
  echo "JCS_SubjectsMain.sh - File $rejectedWordsByRegExs does not exist."
  echo "JCS_SubjectsMain.sh - It will be created"  
  touch "$rejectedWordsByRegExs"
fi

# Here arguments are OK
echo
echo "JCS_SubjectsMain.sh - file2beRead           = " "$file2beRead"
echo "JCS_SubjectsMain.sh - dirBaseName           = " "$dirBaseName"
echo "JCS_SubjectsMain.sh - onlyWords             = " "$onlyWords"
echo "JCS_SubjectsMain.sh - rejectedWords         = " "$rejectedWords"
echo "JCS_SubjectsMain.sh - rejectedWordsByRegExs = " "$rejectedWordsByRegExs"
echo

############################################################################
#   Calling wordsOnly
#
#   input : 1) ~/Documents/TXT/selectBooks/BookLists/AllBooks.txt
#           2) ~/BookCollection/
#
#   output: 1) selectedBooks_OnlyWords.txt
#           2) selectedBooks_RejectedWords.txt
#           3) selectedBooks_RejectedByRegExs.txt
############################################################################
echo "JCS_SubjectsMain.sh - ========== calling 'wordsOnly' =============="
wordsOnly "$file2beRead" "$dirBaseName" "$onlyWords" "$rejectedWords" "$rejectedWordsByRegExs"

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   Preparing variables to the SORT and to removePlural
############################################################################
mapfile -t < ~/sh_JCS/JCS_SubjectsArguments2.txt

for i in ${!MAPFILE[@]}; 
do
  echo "element $i is ${MAPFILE[$i]}"
  var$i=${MAPFILE[$i]}
  
  case "$i" in
        0)  OnlyWordsSorted=${MAPFILE[0]}
            echo "${MAPFILE[0]}"
           ;;
        1)  SubjectsWithoutPlural=${MAPFILE[1]}
            echo "${MAPFILE[1]}"
           ;;
        2)  SubjectsWithPlural=${MAPFILE[2]}
            echo "${MAPFILE[1]}"
           ;;
        3)  EncodedWords=${MAPFILE[3]}
            echo "${MAPFILE[1]}"
           ;;
        *)  echo " Invalid value"
           ;;
  esac
  
done

# Received arguments
echo
echo "JCS_SubjectsMain.sh - OnlyWordsSorted       = " "$OnlyWordsSorted"
echo "JCS_SubjectsMain.sh - SubjectsWithoutPlural = " "$SubjectsWithoutPlural"
echo "JCS_SubjectsMain.sh - SubjectsWithPlural    = " "$SubjectsWithPlural"
echo "JCS_SubjectsMain.sh - EncodedWords          = " "$EncodedWords"
echo

############################################################################
#   Calling sort unique (-u)
#
#   LC_COLLATE=C must be used for special chars be classified before any
#   letter
############################################################################
echo "JCS_SubjectsMain.sh - ========== sort -u =============="
LC_COLLATE=C sort -u "$onlyWords" > "$OnlyWordsSorted"

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   Calling removePlural
#
#   input : 1) selectedBooks_OnlyWordsSorted.txt
#
#   output: 1) selectedBooks_SubjectsWithoutPlural.txt
#           2) selectedBooks_WordsWithPlural.txt
############################################################################
echo "JCS_SubjectsMain.sh - ========== calling 'removePlural' =============="
removePlural "$OnlyWordsSorted" "$SubjectsWithoutPlural" "$SubjectsWithPlural"
    
if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   Calling Soundex
#
#   input : 1)selectedBooks_SubjectsWithoutPlural.txt
#           2) "4" - last parameter - phonetic code size that may be 
#               from 4 to 7 (Default size of the phonetic code)
#
#   output: 1) selectedBooks_EncodedWords.txt
############################################################################
echo "JCS_SubjectsMain.sh - ========== calling 'Soundex' =============="
Soundex "$SubjectsWithoutPlural" "$EncodedWords" 4
    
if [ $? -ne 0 ] 
then
    exit 1
else
    exit 0
fi
