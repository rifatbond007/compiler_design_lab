/*
 * Lab 10 - Flex scanner for the simple calculator.
 *
 * Recognises:
 *   - numbers (integer and floating-point)
 *   - operators: + - * /
 *   - parentheses
 *   - newlines
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%%

[ \t\r]+       { /* ignore spaces and tabs */ }
\n             { return '\n'; }

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? {
    yylval.dval = atof(yytext);
    return NUMBER;
}

[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?    {
    yylval.dval = atof(yytext);
    return NUMBER;
}

"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"("             { return '('; }
")"             { return ')'; }

.               {
    fprintf(stderr, "[ERROR] Unexpected character: '%s'\n", yytext);
    return YYUNDEF;
}

%%

int yywrap(void)
{
    return 1;
}