/*
 * Lab 08 - Bison expression validator.
 *
 * Parses arithmetic expressions and reports whether each one is
 * valid. Each line after the user presses ENTER is reported as
 * either "Valid Expression" or "Invalid Expression".
 *
 * Supported tokens:
 *   - numbers       (integer or floating-point)
 *   - identifiers   (alphanumeric, starting with letter or underscore)
 *   - operators     + - * /
 *   - parentheses   ( )
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

extern int  yylex(void);
extern int  yyparse(void);
extern char *yytext;
extern FILE *yyin;
extern void  yyerror(const char *s);

static int parse_error = 0;
%}

%union {
    char *sval;
}

%token <sval> NUMBER
%token <sval> IDENT

%left  '+' '-'
%left  '*' '/'
%right UMINUS

%%

input
    : /* empty */
    | input line
    ;

line
    : expr '\n'      {
                        if (!parse_error) {
                            printf("Valid Expression\n");
                            fflush(stdout);
                        }
                        parse_error = 0;
                    }
    | '\n'            {
                        /* Empty line: end interactive input. */
                        YYACCEPT;
                    }
    | error '\n'      {
                        printf("Invalid Expression\n");
                        fflush(stdout);
                        yyerrok;
                        parse_error = 0;
                    }
    ;

expr
    : expr '+' term
    | expr '-' term
    | term
    ;

term
    : term '*' factor
    | term '/' factor
    | factor
    ;

factor
    : '(' expr ')'
    | NUMBER
    | IDENT
    | '-' factor %prec UMINUS
    ;

%%

int main(void)
{
    printf("=========================================\n");
    printf(" Lab 08 - Bison Expression Validator\n");
    printf("=========================================\n");
    printf("Type arithmetic expressions line by line.\n");
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
    parse_error = 1;
}
