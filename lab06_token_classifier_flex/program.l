/*
 * Lab 06 - Flex Token Classifier
 *
 * Reads C-like source code interactively and classifies every
 * token into one of: Keyword, Identifier, Number, Operator,
 * Separator, String, Character.
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static long count_keyword    = 0;
static long count_identifier = 0;
static long count_number     = 0;
static long count_operator   = 0;
static long count_separator  = 0;
static long count_string     = 0;
static long count_character  = 0;

static int is_keyword(const char *s);
%}

KEYWORD  auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while

%%

{KEYWORD}        { printf("  %-16s -> Keyword\n", yytext);    count_keyword++;    }

\"([^"\\]|\\.)*\"   { printf("  %-16s -> String\n", yytext);      count_string++;     }

\'([^'\\]|\\.)*\'   { printf("  %-16s -> Character\n", yytext);   count_character++;  }

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? { printf("  %-16s -> Number\n", yytext); count_number++; }
[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?    { printf("  %-16s -> Number\n", yytext); count_number++; }

[a-zA-Z_][a-zA-Z0-9_]*   {
                    if (is_keyword(yytext)) {
                        printf("  %-16s -> Keyword\n", yytext);
                        count_keyword++;
                    } else {
                        printf("  %-16s -> Identifier\n", yytext);
                        count_identifier++;
                    }
                }

"++"|"--"|"+="|"-="|"*="|"/="|"%="|"=="|"!="|"<="|">="|"&&"|"||"|"<<"|">>"|"<<="|">>=" {
                    printf("  %-16s -> Operator\n", yytext);
                    count_operator++;
                }

[+\-*/%=<>!&|^~]   { printf("  %-16s -> Operator\n", yytext);   count_operator++;   }

[(){}\[\];,]    { printf("  %-16s -> Separator\n", yytext);  count_separator++;  }

\n              { /* newline ends a line; output prints on each token */ }

[ \t]+          { }

.               { printf("  %-16s -> Unknown\n", yytext);     count_operator++;   }

%%

static int is_keyword(const char *s)
{
    static const char *list[] = {
        "auto","break","case","char","const","continue","default","do",
        "double","else","enum","extern","float","for","goto","if","int",
        "long","register","return","short","signed","sizeof","static",
        "struct","switch","typedef","union","unsigned","void","volatile",
        "while", NULL
    };
    for (int i = 0; list[i] != NULL; i++) {
        if (strcmp(s, list[i]) == 0) return 1;
    }
    return 0;
}

int main(void)
{
    printf("Type C-like source code; press ENTER on an empty line to finish.\n");
    yylex();
    long total = count_keyword + count_identifier + count_number +
                 count_operator + count_separator + count_string +
                 count_character;
    printf("Keywords    : %ld\n", count_keyword);
    printf("Identifiers : %ld\n", count_identifier);
    printf("Numbers     : %ld\n", count_number);
    printf("Operators   : %ld\n", count_operator);
    printf("Separators  : %ld\n", count_separator);
    printf("Strings     : %ld\n", count_string);
    printf("Characters  : %ld\n", count_character);
    printf("Total       : %ld\n", total);
    return EXIT_SUCCESS;
}

int yywrap(void)
{
    return 1;
}