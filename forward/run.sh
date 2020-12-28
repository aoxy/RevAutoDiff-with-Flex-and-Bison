#!/bin/bash
if [ -f autodiff ]; then rm autodiff; fi
bison -d diff.y
flex diff.l
gcc lex.yy.c diff.tab.c -lm -o autodiff

printf "样例1："
cat input.txt
printf "\n"
./autodiff < input.txt
printf "\n"

printf "样例2："
cat input2.txt
printf "\n"
./autodiff < input2.txt
printf "\n"

printf "样例3："
cat input3.txt
printf "\n"
./autodiff < input3.txt
printf "\n"