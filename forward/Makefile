all : autodiff check
autodiff: lex.yy.o diff.tab.o
	gcc -o autodiff lex.yy.o diff.tab.o -lm
check: check.c
	gcc -o check check.c -lm
lex.yy.o: diff.l
	bison -d diff.y; flex diff.l; gcc -c lex.yy.c -lm
diff.tab.o: diff.y
	gcc -c diff.tab.c -lm
clean:
	rm -f autodiff check *.o diff.tab.[ch] lex.yy.c