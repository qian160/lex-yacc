%{
// note that lex always tries to match the longest possible string
#include "y.tab.h"
%}

%%

[ \t]*                  { /* skip blanks*/ }
\n                      { return '\n'; }
0[bB][01]+              { yylval = strtoimax(yytext+2, NULL, 2); return NUMBER; }
0|[1-9][0-9]*           { yylval = strtoimax(yytext, NULL, 10);  return NUMBER; }
0[xX][0-9a-fA-F]+       { yylval = strtoimax(yytext, NULL, 16);  return NUMBER; }
"=="                    { return EQ; }
"!="                    { return NEQ; }
"<="                    { return LET; }
">="                    { return GET; }
"<<"                    { return SL; }
">>"                    { return SR; }
exit                    { exit(0); }
.                       { return yytext[0]; }



%%