/*
 * Lab 08 - Bison expression validator.
 *
 * Parses arithmetic expressions and reports whether each one is
 * valid. Each line is reported as "Valid Expression" or
 * "Invalid Expression". Press ENTER on an empty line to finish.
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
extern char *yytext;
extern void yyerror(const char *s);

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
                        if (!parse_error) printf("Valid Expression\n");
                        parse_error = 0;
                    }
    | '\n'            { YYACCEPT; }
    | error '\n'      {
                        printf("Invalid Expression\n");
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
    printf("Type arithmetic expressions; press ENTER on an empty line to finish.\n");
    yyparse();
    return EXIT_SUCCESS;
}

void yyerror(const char *s)
{
    (void)s;
    parse_error = 1;
}