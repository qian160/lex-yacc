calculator:	lexer.i parser.y y.tab.h
	lex lexer.i && yacc parser.y -d
	gcc y.tab.c -ll -o $@

clean:
	
