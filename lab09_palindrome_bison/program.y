/*
 * Lab 09 - Bison palindrome checker.
 *
 * For each non-empty line submitted by the user, the program
 * checks whether the input is a palindrome (reads the same forward
 * and backward). The result is printed as either "Palindrome" or
 * "Not Palindrome".
 *
 * Input ends when the user presses ENTER on an empty line.
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern int  yylex(void);
extern int  yyparse(void);
extern FILE *yyin;
extern void  yyerror(const char *s);

static int is_palindrome(const char *s);
%}

%union {
    char *sval;
}

%token <sval> STRING

%%

input
    : /* empty */
    | input line
    ;

line
    : STRING '\n'    {
                        if (is_palindrome($1)) {
                            printf("Palindrome\n");
                        } else {
                            printf("Not Palindrome\n");
                        }
                        fflush(stdout);
                        free($1);
                    }
    | '\n'            {
                        /* Empty line: end interactive input. */
                        YYACCEPT;
                    }
    | error '\n'      {
                        yyerrok;
                    }
    ;

%%

static int is_palindrome(const char *s)
{
    if (s == NULL) return 0;
    size_t len = strlen(s);
    if (len == 0) return 1;
    for (size_t i = 0, j = len - 1; i < j; i++, j--) {
        if (s[i] != s[j]) {
            return 0;
        }
    }
    return 1;
}

int main(void)
{
    printf("=========================================\n");
    printf(" Lab 09 - Bison Palindrome Checker\n");
    printf("=========================================\n");
    printf("Type a word or phrase line by line.\n");
    printf("Press ENTER on an empty line to finish.\n");
    printf("-----------------------------------------\n");
    fflush(stdout);

    yyparse();

    printf("=========================================\n");
    return EXIT_SUCCESS;
}

void yyerror(const char *s)
{
    (void)s;
}
