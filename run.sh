#!/bin/bash
#
bison -d diff.y
flex diff.l
gcc lex.yy.c diff.tab.c -lm -o diff
./diff < input.txt
