#!/bin/bash
bison -d diff.y
flex diff.l
gcc lex.yy.c diff.tab.c -lm -o diff

printf "样例1："
cat input.txt
printf "\n"
./diff < input.txt
printf "\n"

printf "样例2："
cat input2.txt
printf "\n"
./diff < input2.txt
printf "\n"

printf "样例3："
cat input3.txt
printf "\n"
./diff < input3.txt
printf "\n"