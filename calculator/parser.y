%{
#include <ctype.h>
#include <stdio.h>

/* recursive descent 
    ANY TOKENS LONGER THAN 1 MUST BE RECOGNIZED BY LEX BEFORE, NOT BY YACC
*/
%}

%token 	NUMBER EQ NEQ GET LET SL SR

%left 	'+' '-' '*' '/'
%right	UMINUS

%%

lines:	lines expr '\n'	{ printf("ans = %d\n", $2); }
    |	lines '\n'
    |	/* empty */
    |	error '\n'	    { yyerror("reenter previous line:"); yyerrok; }
;

expr:	equality        { $$ = $1; }
;

equality:
        relational                  { $$ = $1; }
    |   relational EQ relational    { $$ = $1 == $3; }
    |   relational NEQ relational   { $$ = $1 != $3; }
    ;
relational:
        shift                       { $$ = $1; }
    |   shift '>' shift             { $$ = $1 > $3; }
    |   shift '<' shift             { $$ = $1 < $3; }
    |   shift GET shift             { $$ = $1 >= $3; }
    |   shift LET shift             { $$ = $1 <= $3; }
    ;
shift:
        add                 { $$ = $1; }
    |   add SL add          { $$ = $1 << $3; }
    |   add SR add          { $$ = $1 >> $3; }
    ;
add:    mul                 { $$ = $1; }
    |   mul '+' mul         { $$ = $1 + $3; }
    |   mul '-' mul         { $$ = $1 - $3; }
    ;

mul:    unary               { $$ = $1; }
    |   unary '*' unary     { $$ = $1 * $3; }
    |   unary '/' unary     { $$ = $1 / $3; }
    ;

unary:  primary             { $$ = $1; }
    |   '-' unary           { $$ = -$2; }
    |   '+' unary           { $$ = $2; }
    |   '!' unary           { $$ = !$2; }
    |   '~' unary           { $$ = ~$2; }
    ;

primary:    '(' expr ')'    { $$ = $2; }
    |   NUMBER              { $$ = $1; }
    ;

%%

#include "lex.yy.c"
extern FILE *yyin;

void yyerror(const char *s){
	fprintf(stderr, "%s\n", s);
}

int main()
{
    printf("\33[0;93m[ welcome!🙂] \n\33[0m");
    do
    {
        yyparse();

    }
    while (!feof(yyin));
}