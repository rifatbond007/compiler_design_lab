/*
 * Lab 09 - Flex scanner for the palindrome checker.
 *
 * Captures each input line as a STRING token (without the trailing
 * newline) and returns it. Newlines are returned as a literal '\n'
 * so the parser can use them to detect line boundaries.
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

[ \t]+         { /* ignore leading whitespace */ }
\n             { return '\n'; }

[^\n]+         {
                    /* Capture everything up to (but not including) the
                     * newline as the line string. Trim leading whitespace. */
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
