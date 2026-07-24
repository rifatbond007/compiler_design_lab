/*
 * Lab 05 - Flex Word Counter
 *
 * Counts words in interactive input. A word is any sequence of
 * letters, digits, or underscores. Press ENTER on an empty line
 * to finish.
 *
 * Author: riftbond007
 */

%{
#include <stdio.h>
#include <stdlib.h>

static long total_words = 0;
static int  line_started = 0;
%}

%%

[[:alnum:]_]+    { line_started = 1; total_words++; }

\n                {
        if (line_started) line_started = 0;
        else yyterminate();
    }

[ \t]+           { }

.                { line_started = 1; }

%%

int main(void)
{
    printf("Type text line by line; press ENTER on an empty line to finish.\n");
    yylex();
    printf("Total Words : %ld\n", total_words);
    return EXIT_SUCCESS;
}

int yywrap(void)
{
    return 1;
}