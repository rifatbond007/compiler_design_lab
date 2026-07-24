/*
 * Lab 10 - Bison grammar for the simple calculator.
 *
 * Evaluates arithmetic expressions with correct precedence.
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

static int parse_error = 0;
static void print_result(double v);
%}

%union {
    double dval;
}

%token <dval> NUMBER

%left  '+' '-'
%left  '*' '/'
%right UMINUS

%type  <dval> expr term factor

%%

input
    : /* empty */
    | input line
    ;

line
    : expr '\n'           {
                            if (!parse_error) print_result($1);
                            parse_error = 0;
                        }
    | '\n'                { YYACCEPT; }
    | error '\n'          {
                            printf("  -> Invalid Expression\n");
                            yyerrok;
                            parse_error = 0;
                        }
    ;

expr
    : expr '+' term       { $$ = $1 + $3; }
    | expr '-' term       { $$ = $1 - $3; }
    | term                { $$ = $1; }
    ;

term
    : term '*' factor     { $$ = $1 * $3; }
    | term '/' factor     {
                            if ($3 == 0.0) {
                                printf("  -> Error: division by zero\n");
                                parse_error = 1;
                                $$ = 0.0;
                            } else {
                                $$ = $1 / $3;
                            }
                        }
    | factor              { $$ = $1; }
    ;

factor
    : '(' expr ')'        { $$ = $2; }
    | NUMBER              { $$ = $1; }
    | '-' factor %prec UMINUS { $$ = -$2; }
    ;

%%

static void print_result(double v)
{
    if (v == (double)(long long)v) printf("  = %lld\n", (long long)v);
    else                            printf("  = %g\n", v);
}

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