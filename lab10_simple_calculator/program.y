/*
 * Lab 10 - Bison grammar for the simple calculator.
 *
 * Evaluates arithmetic expressions with correct precedence:
 *   - + and - have lower precedence
 *   - * and / have higher precedence
 *   - parentheses override precedence
 *   - unary minus is supported
 *
 * Each submitted line is evaluated and the result is printed.
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
extern FILE *yyin;
extern void  yyerror(const char *s);

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
                            if (!parse_error) {
                                print_result($1);
                            }
                            parse_error = 0;
                        }
    | '\n'                {
                            /* Empty line: end interactive input. */
                            YYACCEPT;
                        }
    | error '\n'          {
                            printf("  -> Invalid Expression\n");
                            fflush(stdout);
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
                                fflush(stdout);
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
    /* Print without trailing zeros for whole numbers. */
    if (v == (double)(long long)v) {
        printf("  = %lld\n", (long long)v);
    } else {
        printf("  = %g\n", v);
    }
    fflush(stdout);
}

int main(void)
{
    printf("=========================================\n");
    printf(" Lab 10 - Lex + Yacc Calculator\n");
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
