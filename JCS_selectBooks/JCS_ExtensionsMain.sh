#!/bin/bash
#--------------------------------------------------------------------------
#SCRIPT: JCS_ExtensionsMain.sh
#
#PURPOSE: Read the AllBooks file and create:
#           A File with all Extensions
#           A File with all Rejected Extensions
#           A File with all ExtensionsSortedByName
#           A File with all ExtensionsSortedByOccurrences
#
#   OBS: All parameters were already checked in script JCS_Extensions.sh
#--------------------------------------------------------------------------

############################################################################
#             Helper Constants
############################################################################
scriptName="JCS_ExtensionsMain.sh"

# Saving arguments
file2beRead=$1
extensionsFile=$2
rejectedExtensionsFile=$3
ExtensionsSortedByName=$4
ExtensionsSortedByOccurrences=$5

############################################################################
#   Calling getExtensions
############################################################################
echo "$scriptName - ========== getExtensions will be called =============="
getExtensions  "$file2beRead"  "$extensionsFile"  "$rejectedExtensionsFile"

if [ $? -ne 0 ] 
then
    echo "$scriptName - ========== 'getExtensions  E  R  R  O  R' =============="
    exit 1
fi

############################################################################
#   sort extensions by name
############################################################################
echo "$scriptName - ========== sort extensions by name =============="
sort "$extensionsFile" > "$ExtensionsSortedByName"

if [ $? -ne 0 ]
then
    echo "$scriptName - ========== 'sort extensions by name  E  R  R  O  R' =============="
    exit 1
fi

############################################################################
#   sort extensions by number of occurrences 
############################################################################
echo "$scriptName - ==== sort -n --key=2.1 --key=1.2  extensions by number of occurrences ========"
sort -n --key=2.1 --key=1.2 "$extensionsFile" > "$ExtensionsSortedByOccurrences"
#
if [ $? -ne 0 ] 
then
    echo "$scriptName - ===== 'sort extensions by number of occurrences  E  R  R  O  R' ======="
    exit 1
else
    echo "$scriptName - ================= 'ALL IS WELL !!' ====================="
    exit 0
fi
