#!/bin/bash
#---------------------------------------------------------------------------
#SCRIPT: JCS_Subjects.sh
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
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
#             Helper Constants
#---------------------------------------------------------------------------
scriptName="JCS_Subjects.sh"

#---------------------------------------------------------------------------
#             Reading parameters
#---------------------------------------------------------------------------
mapfile -t < ~/sh_JCS/JCS_SubjectsArguments.txt

for i in "${!MAPFILE[@]}"; 
do
  echo "Parameter $i is ${MAPFILE[$i]}"
  
  case "$i" in
        0)  file2beRead=${MAPFILE[0]}
            echo "${MAPFILE[0]}"
           ;;
        1)  dirBaseName=${MAPFILE[1]}
            echo "${MAPFILE[1]}"
           ;;
        2)  onlyWords=${MAPFILE[2]}
            echo "${MAPFILE[2]}"
           ;;
        3)  rejectedWords=${MAPFILE[3]}
            echo "${MAPFILE[3]}"
           ;;
        4)  rejectedWordsByRegExs=${MAPFILE[4]}
            echo "${MAPFILE[4]}"
           ;;
        *)  echo "$scriptName - Inform 5 File names:" 
            echo "$scriptName - 1-File with a list of all books"
            echo "$scriptName - 2-Directory base name of the Book collection"
            echo "$scriptName - 3-File that will receive Only Words"
            echo "$scriptName - 4-File that will receive Rejected Words"
            echo "$scriptName - 5-File that will receive Rejected Words By RegExs"
            echo "$scriptName - Script will terminate"
            exit 1
           ;;
  esac  
done

# Verifying arguments
if [ ! -f "$file2beRead" ]; then
  echo "$scriptName - File $file2beRead does not exist."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

if [ ! -d "$dirBaseName" ]; then
  echo "$scriptName - File $dirBaseName does not exist."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

if [ ! -f "$onlyWords" ]; then
  echo "$scriptName - File $onlyWords does not exist."
  echo "$scriptName - It will be created"  
  touch "$onlyWords"
fi

if [ ! -f "$rejectedWords" ]; then
  echo "$scriptName - File $rejectedWords does not exist."
  echo "$scriptName - It will be created"  
  touch "$rejectedWords"
fi

if [ ! -f "$rejectedWordsByRegExs" ]; then
  echo "$scriptName - File $rejectedWordsByRegExs does not exist."
  echo "$scriptName - It will be created"  
  touch "$rejectedWordsByRegExs"
fi

# Here arguments are OK
echo
echo "$scriptName - file2beRead           = " "$file2beRead"
echo "$scriptName - dirBaseName           = " "$dirBaseName"
echo "$scriptName - onlyWords             = " "$onlyWords"
echo "$scriptName - rejectedWords         = " "$rejectedWords"
echo "$scriptName - rejectedWordsByRegExs = " "$rejectedWordsByRegExs"
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
echo "$scriptName - ========== calling 'wordsOnly' =============="
wordsOnly "$file2beRead" "$dirBaseName" "$onlyWords" "$rejectedWords" "$rejectedWordsByRegExs"

if [ $? -ne 0 ] 
then
    echo "$scriptName - ===========  wordsOnly   E  R  R  O  R  ==========="
    exit 1
fi

############################################################################
#   Preparing variables to the SORT and to removePlural
############################################################################
mapfile -t < ~/sh_JCS/JCS_SubjectsArguments2.txt

for i in "${!MAPFILE[@]}";
do
  echo "Parameter $i is ${MAPFILE[$i]}"
  
  case "$i" in
        0)  OnlyWordsSorted=${MAPFILE[0]}
            echo "${MAPFILE[0]}"
           ;;
        1)  SubjectsWithoutPlural=${MAPFILE[1]}
            echo "${MAPFILE[1]}"
           ;;
        2)  SubjectsWithPlural=${MAPFILE[2]}
            echo "${MAPFILE[2]}"
           ;;
        3)  EncodedWords=${MAPFILE[3]}
            echo "${MAPFILE[3]}"
           ;;
        *)  echo "$scriptName - Inform 4 parameters:" 
            echo "$scriptName - 1-File that will receive OnlyWordsSorted"
            echo "$scriptName - 2-File that will receive SubjectsWithoutPlural"
            echo "$scriptName - 3-File that will receive SubjectsWithPlural"
            echo "$scriptName - 4-File that will receive EncodedWords"            
            echo "$scriptName - Script will terminate"
            exit 1
           ;;
  esac  
done

# Verifying arguments
if [ ! -f "$OnlyWordsSorted" ]; then
  echo "$scriptName - File $OnlyWordsSorted does not exist."
  echo "$scriptName - It will be created"  
  touch "$OnlyWordsSorted"
fi

if [ ! -f "$SubjectsWithoutPlural" ]; then
  echo "$scriptName - File $SubjectsWithoutPlural does not exist."
  echo "$scriptName - It will be created"  
  touch "$SubjectsWithoutPlural"
fi

if [ ! -f "$SubjectsWithPlural" ]; then
  echo "$scriptName - File $SubjectsWithPlural does not exist."
  echo "$scriptName - It will be created"  
  touch "$SubjectsWithPlural"
fi

if [ ! -f "$EncodedWords" ]; then
  echo "$scriptName - File $EncodedWords does not exist."
  echo "$scriptName - It will be created"  
  touch "$EncodedWords"
fi


# Here arguments are OK
echo
echo "$scriptName - OnlyWordsSorted       = " "$OnlyWordsSorted"
echo "$scriptName - SubjectsWithoutPlural = " "$SubjectsWithoutPlural"
echo "$scriptName - SubjectsWithPlural    = " "$SubjectsWithPlural"
echo "$scriptName - EncodedWords          = " "$EncodedWords"
echo

############################################################################
#   Calling sort unique (-u)
#
#   LC_COLLATE=C must be used for special chars be classified before any
#   letter
############################################################################
echo "$scriptName - ========== sort -u =============="
LC_COLLATE=C sort -u "$onlyWords" > "$OnlyWordsSorted"

if [ $? -ne 0 ]
then
    echo "$scriptName - ===========  LC_COLLATE=C sort -u   E  R  R  O  R  ==========="
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
echo "$scriptName - ========== calling 'removePlural' =============="
removePlural "$OnlyWordsSorted" "$SubjectsWithoutPlural" "$SubjectsWithPlural"
    
if [ $? -ne 0 ] 
then
    echo "$scriptName - ===========  removePlural   E  R  R  O  R  ==========="
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
echo "$scriptName - ========== calling 'Soundex' =============="

PhoneticCodeLength=4

Soundex "$SubjectsWithoutPlural" "$EncodedWords" "$PhoneticCodeLength"
    
if [ $? -ne 0 ] 
then
    echo "$scriptName - ===============  Soundex   E  R  R  O  R  ============="
    exit 1
else
    echo "$scriptName - ==================  ALL IS WELL !!  ===================== "
    exit 0
fi
