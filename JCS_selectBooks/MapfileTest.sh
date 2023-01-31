#!/bin/bash
#
mapfile -t < ~/sh_JCS/JCS_SelectBooksArguments.txt

for i in ${!MAPFILE[@]}; 
do
  echo "element $i is ${MAPFILE[$i]}"
  var$i=${MAPFILE[$i]}
  
  case "$i" in
        0)  var0=${MAPFILE[0]}
            echo "var0 = $var0"
           ;;
        1)  var1=${MAPFILE[1]}
            echo "var1 = $var1"
           ;;
        2)  var2=${MAPFILE[2]}
            echo "var2 = $var2"
           ;;
        3)  var3=${MAPFILE[3]}
            echo "var3 = $var3"
           ;;
        4)  var4=${MAPFILE[4]}
            echo "var4 = $var4"
           ;;
        5)  var5=${MAPFILE[5]}
            echo "var5 = $var5"
           ;;
        6)  var6=${MAPFILE[6]}
            echo "var6 = $var6"
           ;;
        7)  var7=${MAPFILE[7]}
            echo "var7 = $var7"
           ;;
        *)  echo " Invalid value"
           ;;
esac
  
done

echo "var1 = " $var1
echo "var2 = " $var2

exit 0
