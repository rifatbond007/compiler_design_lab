/*
 * ============================================================
 * Lab 05 - Flex Word Counter
 * ============================================================
 *
 * Description:
 *   Flex scanner that counts words in interactive input. A word
 *   is any contiguous sequence of letters, digits, or underscores.
 *
 *   The user types text line by line. Input ends when the user
 *   presses ENTER on an empty line. Only then is the final count
 *   displayed.
 *
 * The generated scanner is compiled by run.sh, which keeps the
 * generated files temporary and removes them after execution.
 *
 * Author: riftbond007
 * ============================================================
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>

static long total_words  = 0;
static int  line_started = 0;

static void print_total(void);
%}

%%

[[:alnum:]_]+    {
        line_started = 1;
        total_words++;
    }

\n                {
        if (line_started) {
            /* Newline ends the current line, but does not print output. */
            line_started = 0;
        } else {
            /* Empty line ends interactive input. */
            yyterminate();
        }
    }

[ \t]+           {
        /* Spaces and tabs separate words. */
    }

.                {
        /* Punctuation is input content, but not a word. */
        line_started = 1;
    }

%%

static void print_total(void)
{
    printf("\n=========================================\n");
    printf(" Lab 05 - Flex Word Counter\n");
    printf("=========================================\n");
    printf("Total Words : %ld\n", total_words);
    printf("=========================================\n");
}

int main(void)
{
    printf("=========================================\n");
    printf(" Lab 05 - Flex Word Counter\n");
    printf("=========================================\n");
    printf("Type text line by line.\n");
    printf("Press ENTER on an empty line to finish.\n");
    printf("-----------------------------------------\n");
    fflush(stdout);

    yylex();

    print_total();
    return EXIT_SUCCESS;
}

int yywrap(void)
{
    return 1;
}