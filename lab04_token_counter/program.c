/*
 * Lab 04 - Token Counter
 *
 * Reads C-like source code interactively, counting keywords,
 * identifiers, operators, constants, and separators.
 *
 * Author: riftbond007
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_TOKEN_LEN 64
#define MAX_LINE_LEN  4096

static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default",
    "do", "double", "else", "enum", "extern", "float", "for", "goto",
    "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union",
    "unsigned", "void", "volatile", "while", NULL
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

static int is_number(const char *token)
{
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

static long count_keywords = 0;
static long count_identifiers = 0;
static long count_operators = 0;
static long count_constants = 0;
static long count_separators = 0;

static void process_line(const char *line)
{
    char token[MAX_TOKEN_LEN];
    int i = 0, t = 0;

    while (line[i] != '\0') {
        char c = line[i];

        if (isspace((unsigned char)c)) { i++; continue; }

        if (c == '/' && line[i + 1] == '/') break;
        if (c == '/' && line[i + 1] == '*') {
            i += 2;
            while (line[i] != '\0' && !(line[i] == '*' && line[i + 1] == '/')) i++;
            if (line[i] != '\0') i += 2;
            continue;
        }
        if (c == '"' || c == '\'') {
            char quote = c;
            i++;
            while (line[i] != '\0' && line[i] != quote) {
                if (line[i] == '\\' && line[i + 1] != '\0') i++;
                i++;
            }
            if (line[i] != '\0') i++;
            count_constants++;
            continue;
        }

        if (isalpha((unsigned char)c) || c == '_' || isdigit((unsigned char)c)) {
            t = 0;
            while (line[i] != '\0' &&
                   (isalnum((unsigned char)line[i]) || line[i] == '_' || line[i] == '.')) {
                if (t < MAX_TOKEN_LEN - 1) token[t++] = line[i];
                i++;
            }
            token[t] = '\0';

            if (is_keyword(token)) count_keywords++;
            else if (is_number(token)) count_constants++;
            else count_identifiers++;
            continue;
        }

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

        if (strchr("(){}[];,.", c) != NULL) {
            count_separators++;
            i++;
            continue;
        }
        i++;
    }
}

int main(void)
{
    char line[MAX_LINE_LEN];
    int line_no = 0;

    printf("Type C-like source code; press ENTER on an empty line to finish.\n");

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

    printf("Lines read   : %d\n", line_no);
    printf("Keywords     : %ld\n", count_keywords);
    printf("Identifiers  : %ld\n", count_identifiers);
    printf("Operators    : %ld\n", count_operators);
    printf("Constants    : %ld\n", count_constants);
    printf("Separators   : %ld\n", count_separators);
    printf("Total        : %ld\n", total);
    return 0;
}