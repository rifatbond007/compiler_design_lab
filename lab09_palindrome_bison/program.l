/*
 * Lab 09 - Flex scanner for the palindrome checker.
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

%%

[ \t]+         { }
\n             { return '\n'; }

[^\n]+         {
                    char *p = yytext;
                    while (*p == ' ' || *p == '\t') p++;
                    yylval.sval = strdup(p);
                    return STRING;
                }

%%

int yywrap(void)
{
    return 1;
}