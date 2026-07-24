/*
 * Lab 09 - Bison palindrome checker.
 *
 * For each non-empty line, prints "Palindrome" or "Not Palindrome".
 * Press ENTER on an empty line to finish.
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(void);
extern int yyparse(void);
extern void yyerror(const char *s);

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
                        if (is_palindrome($1)) printf("Palindrome\n");
                        else                   printf("Not Palindrome\n");
                        free($1);
                    }
    | '\n'            { YYACCEPT; }
    | error '\n'      { yyerrok; }
    ;

%%

static int is_palindrome(const char *s)
{
    if (s == NULL) return 0;
    size_t len = strlen(s);
    if (len == 0) return 1;
    for (size_t i = 0, j = len - 1; i < j; i++, j--) {
        if (s[i] != s[j]) return 0;
    }
    return 1;
}

int main(void)
{
    printf("Type a word or phrase; press ENTER on an empty line to finish.\n");
    yyparse();
    return EXIT_SUCCESS;
}

void yyerror(const char *s)
{
    (void)s;
}