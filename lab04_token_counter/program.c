/*
 * ============================================================
 * Lab 04 - Token Counter
 * ============================================================
 *
 * Description:
 *   Interactive program that reads C-like source code line by
 *   line from the user, ending on an empty line. It then counts
 *   the total number of tokens broken into the following
 *   categories:
 *       - Keywords
 *       - Identifiers
 *       - Operators
 *       - Constants
 *       - Separators
 *   and prints the total token count as well.
 *
 * Usage:
 *   ./program
 *
 * Author: riftbond007
 * ============================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_TOKEN_LEN  64
#define MAX_LINE_LEN   4096

/* ---------- C reserved keywords ---------- */
static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default",
    "do", "double", "else", "enum", "extern", "float", "for", "goto",
    "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union",
    "unsigned", "void", "volatile", "while",
    NULL
};

static int in_list(const char *token, const char *list[])
{
    for (int i = 0; list[i] != NULL; i++) {
        if (strcmp(token, list[i]) == 0) return 1;
    }
    return 0;
}

static int is_keyword(const char *token)
{
    return in_list(token, keywords);
}

/* Returns 1 if the token is a numeric literal. */
static int is_number(const char *token)
{
    if (token == NULL || token[0] == '\0') return 0;
    int seen_dot = 0;
    for (size_t i = 0; token[i] != '\0'; i++) {
        if (token[i] == '.') {
            if (seen_dot) return 0;
            seen_dot = 1;
        } else if (!isdigit((unsigned char)token[i])) {
            return 0;
        }
    }
    return 1;
}

/* ---------- Counters ---------- */
static long count_keywords     = 0;
static long count_identifiers  = 0;
static long count_operators    = 0;
static long count_constants    = 0;
static long count_separators   = 0;

/* ---------- Tokenize one line ---------- */
static void process_line(const char *line)
{
    char token[MAX_TOKEN_LEN];
    int  i = 0, t = 0;

    while (line[i] != '\0') {
        char c = line[i];

        /* Skip whitespace. */
        if (isspace((unsigned char)c)) {
            i++;
            continue;
        }

        /* Skip single-line comments. */
        if (c == '/' && line[i + 1] == '/') {
            break;
        }
        /* Skip multi-line comments on a single line. */
        if (c == '/' && line[i + 1] == '*') {
            i += 2;
            while (line[i] != '\0' && !(line[i] == '*' && line[i + 1] == '/')) {
                i++;
            }
            if (line[i] != '\0') i += 2;
            continue;
        }

        /* Skip string/char literals. */
        if (c == '"' || c == '\'') {
            char quote = c;
            i++;
            while (line[i] != '\0' && line[i] != quote) {
                if (line[i] == '\\' && line[i + 1] != '\0') i++;
                i++;
            }
            if (line[i] != '\0') i++;
            /* Both character literals ('x') and string literals ("abc")
             * are counted as constants because they are literal values. */
            count_constants++;
            continue;
        }

        /* Identifier / keyword / number. */
        if (isalpha((unsigned char)c) || c == '_' || isdigit((unsigned char)c)) {
            t = 0;
            while (line[i] != '\0' &&
                   (isalnum((unsigned char)line[i]) || line[i] == '_' ||
                    line[i] == '.')) {
                if (t < MAX_TOKEN_LEN - 1) {
                    token[t++] = line[i];
                }
                i++;
            }
            token[t] = '\0';

            if (is_keyword(token)) {
                count_keywords++;
            } else if (is_number(token)) {
                count_constants++;
            } else {
                count_identifiers++;
            }
            continue;
        }

        /* Operators: one or two character common operators. */
        if (strchr("+-*/%=<>!&|^~", c) != NULL) {
            count_operators++;
            if ((c == '=' || c == '!' || c == '<' || c == '>' || c == '+' ||
                 c == '-' || c == '&' || c == '|' || c == '*') &&
                line[i + 1] == '=') {
                i++;
            } else if ((c == '+' && line[i + 1] == '+') ||
                       (c == '-' && line[i + 1] == '-') ||
                       (c == '&' && line[i + 1] == '&') ||
                       (c == '|' && line[i + 1] == '|') ||
                       (c == '<' && line[i + 1] == '<') ||
                       (c == '>' && line[i + 1] == '>')) {
                i++;
            }
            i++;
            continue;
        }

        /* Separators. */
        if (strchr("(){}[];,.", c) != NULL) {
            count_separators++;
            i++;
            continue;
        }

        /* Anything else is ignored. */
        i++;
    }
}

int main(void)
{
    char line[MAX_LINE_LEN];
    int  line_no = 0;

    printf("=========================================\n");
    printf(" Lab 04 - Token Counter\n");
    printf("=========================================\n");
    printf("Type your C-like source code line by line.\n");
    printf("Press ENTER on an empty line to finish.\n");
    printf("-----------------------------------------\n");
    fflush(stdout);

    while (fgets(line, sizeof(line), stdin) != NULL) {
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }
        if (len == 0) break;
        line_no++;
        process_line(line);
    }

    long total = count_keywords + count_identifiers + count_operators +
                 count_constants + count_separators;

    printf("-----------------------------------------\n");
    printf("=========================================\n");
    printf(" Lab 04 - Token Counter\n");
    printf("=========================================\n");
    printf("Lines read   : %d\n", line_no);
    printf("-----------------------------------------\n");
    printf(" Keywords    : %ld\n", count_keywords);
    printf(" Identifiers : %ld\n", count_identifiers);
    printf(" Operators   : %ld\n", count_operators);
    printf(" Constants   : %ld\n", count_constants);
    printf(" Separators  : %ld\n", count_separators);
    printf("-----------------------------------------\n");
    printf(" TOTAL       : %ld\n", total);
    printf("=========================================\n");

    return 0;
}
