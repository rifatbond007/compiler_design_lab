/*
 * ============================================================
 * Lab 06 - Flex Token Classifier
 * ============================================================
 *
 * Description:
 *   Flex scanner that reads C-like source code interactively and
 *   classifies every token into one of the following categories:
 *
 *     - Keyword       (int, float, if, while, return, ...)
 *     - Identifier    (user-defined names)
 *     - Number        (integer or floating-point literals)
 *     - Operator      (+ - * / = < > ! etc.)
 *     - Separator     (parens, braces, commas, semicolons, ...)
 *     - String        ("...")
 *     - Character     ('.')
 *
 *   Each time the user presses ENTER, the program immediately
 *   prints the tokens classified on the line just submitted and
 *   the running totals. Input ends when the user presses ENTER on
 *   an empty line. After that, the final summary is displayed.
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
#include <string.h>

/* ---------- Counters ---------- */
static long count_keyword    = 0;
static long count_identifier = 0;
static long count_number     = 0;
static long count_operator   = 0;
static long count_separator  = 0;
static long count_string     = 0;
static long count_character  = 0;

/* ---------- Per-line buffer ---------- */
#define MAX_LINE_LOG 512
static char line_log[MAX_LINE_LOG];
static size_t line_log_len = 0;
static int    line_active   = 0;

static void line_append(const char *lexeme, const char *category);
static void line_flush(void);

static int is_keyword(const char *s);
%}

/* ---------- Keywords ---------- */
KEYWORD  auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while

%%

{KEYWORD}        { line_append(yytext, "Keyword");      count_keyword++;    }

\"([^"\\]|\\.)*\"   {
                    line_append(yytext, "String");
                    count_string++;
                }

\'([^'\\]|\\.)*\'   {
                    line_append(yytext, "Character");
                    count_character++;
                }

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? {
                    line_append(yytext, "Number");
                    count_number++;
                }

[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?    {
                    line_append(yytext, "Number");
                    count_number++;
                }

[a-zA-Z_][a-zA-Z0-9_]*   {
                    if (is_keyword(yytext)) {
                        line_append(yytext, "Keyword");
                        count_keyword++;
                    } else {
                        line_append(yytext, "Identifier");
                        count_identifier++;
                    }
                }

"++"|"--"|"+="|"-="|"*="|"/="|"%="|"=="|"!="|"<="|">="|"&&"|"||"|"<<"|">>"|"<<="|">>="   {
                    line_append(yytext, "Operator");
                    count_operator++;
                }

[+\-*/%=<>!&|^~]   {
                    line_append(yytext, "Operator");
                    count_operator++;
                }

[(){}\[\];,]    {
                    line_append(yytext, "Separator");
                    count_separator++;
                }

\n              {
                    /* End of a non-empty line: print this line. */
                    if (line_active) {
                        line_flush();
                    }
                    /* End of an empty line: stop input. */
                    else {
                        yyterminate();
                    }
                }

[ \t]+          { /* Spaces and tabs separate tokens silently. */ }

.               {
                    line_append(yytext, "Unknown");
                    count_operator++;
                }

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

static void line_append(const char *lexeme, const char *category)
{
    line_active = 1;
    int n = snprintf(line_log + line_log_len,
                     sizeof(line_log) - line_log_len,
                     "  %-16s -> %s\n", lexeme, category);
    if (n > 0) {
        line_log_len += (size_t)n;
        if (line_log_len >= sizeof(line_log)) {
            line_log_len = sizeof(line_log) - 1;
        }
    }
}

static void line_flush(void)
{
    if (line_log_len > 0) {
        fwrite(line_log, 1, line_log_len, stdout);
        fflush(stdout);
    }
    line_log_len = 0;
    line_active   = 0;
}

static void print_summary(void)
{
    long total = count_keyword + count_identifier + count_number +
                 count_operator + count_separator + count_string +
                 count_character;

    printf("-----------------------------------------\n");
    printf("=========================================\n");
    printf(" Lab 06 - Flex Token Classifier\n");
    printf("=========================================\n");
    printf("Summary of token categories:\n");
    printf("-----------------------------------------\n");
    printf("  Keywords    : %ld\n", count_keyword);
    printf("  Identifiers : %ld\n", count_identifier);
    printf("  Numbers     : %ld\n", count_number);
    printf("  Operators   : %ld\n", count_operator);
    printf("  Separators  : %ld\n", count_separator);
    printf("  Strings     : %ld\n", count_string);
    printf("  Characters  : %ld\n", count_character);
    printf("-----------------------------------------\n");
    printf("  TOTAL       : %ld\n", total);
    printf("=========================================\n");
}

int main(void)
{
    printf("=========================================\n");
    printf(" Lab 06 - Flex Token Classifier\n");
    printf("=========================================\n");
    printf("Type your C-like source code line by line.\n");
    printf("Each ENTER shows the tokens on that line.\n");
    printf("Press ENTER on an empty line to finish.\n");
    printf("-----------------------------------------\n");
    fflush(stdout);

    yylex();

    if (line_active && line_log_len > 0) {
        line_flush();
    }
    print_summary();
    return EXIT_SUCCESS;
}

int yywrap(void)
{
    return 1;
}