autodiff: lex.yy.o diff.tab.o
	gcc -o autodiff lex.yy.o diff.tab.o -lm
lex.yy.o: diff.l
	flex diff.l; gcc -c lex.yy.c -lm
diff.tab.o: diff.y
	bison -d diff.y; gcc -c diff.tab.c -lm
clean:
	rm -f autodiff diff.output *.o diff.tab.c lex.yy.c