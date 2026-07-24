/*
 * Lab 03 - Symbol Table Generator
 *
 * Reads C-like source code interactively and stores datatypes,
 * keywords, identifiers, and numeric literals in a symbol table.
 * Press ENTER on an empty line to finish.
 *
 * Author: riftbond007
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_TOKEN_LEN 64
#define MAX_SYMBOLS 256
#define MAX_LINE_LEN 4096

typedef enum { TOK_DATATYPE, TOK_KEYWORD, TOK_IDENTIFIER, TOK_NUMBER } TokenType;

typedef struct {
    char name[64];
    char type[16];
    char category[16];
} Symbol;

static Symbol table[MAX_SYMBOLS];
static int symbol_count = 0;

static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default",
    "do", "double", "else", "enum", "extern", "float", "for", "goto",
    "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union",
    "unsigned", "void", "volatile", "while", NULL
};

static const char *datatypes[] = {
    "int", "float", "double", "char", "void", "long", "short",
    "signed", "unsigned", NULL
};

static int in_list(const char *token, const char *list[])
{
    for (int i = 0; list[i] != NULL; i++) {
        if (strcmp(token, list[i]) == 0) return 1;
    }
    return 0;
}

static void copy_text(char *dest, size_t size, const char *src)
{
    if (size == 0) return;
    size_t i = 0;
    while (i + 1 < size && src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0';
}

static void add_symbol(const char *name, const char *category, const char *type)
{
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(table[i].name, name) == 0) return;
    }
    if (symbol_count == MAX_SYMBOLS) return;

    copy_text(table[symbol_count].name, sizeof(table[symbol_count].name), name);
    copy_text(table[symbol_count].type, sizeof(table[symbol_count].type), type);
    copy_text(table[symbol_count].category, sizeof(table[symbol_count].category), category);
    symbol_count++;
}

static TokenType classify(const char *token)
{
    if (in_list(token, datatypes)) return TOK_DATATYPE;
    if (in_list(token, keywords)) return TOK_KEYWORD;

    int dot = 0;
    for (size_t i = 0; token[i] != '\0'; i++) {
        if (token[i] == '.') {
            if (dot++) return TOK_IDENTIFIER;
        } else if (!isdigit((unsigned char)token[i])) {
            return TOK_IDENTIFIER;
        }
    }
    return TOK_NUMBER;
}

static void process_line(const char *line, char *last_type)
{
    char token[MAX_TOKEN_LEN];
    int i = 0;

    while (line[i] != '\0') {
        char c = line[i];

        if (isspace((unsigned char)c)) {
            i++;
            continue;
        }
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
            continue;
        }

        if (isalpha((unsigned char)c) || c == '_' || isdigit((unsigned char)c)) {
            int n = 0;
            while (line[i] != '\0' &&
                   (isalnum((unsigned char)line[i]) || line[i] == '_' || line[i] == '.')) {
                if (n < MAX_TOKEN_LEN - 1) token[n++] = line[i];
                i++;
            }
            token[n] = '\0';

            TokenType kind = classify(token);
            char type[16] = "-";
            if (kind == TOK_DATATYPE) {
                copy_text(last_type, 16, token);
                copy_text(type, sizeof(type), token);
                add_symbol(token, "Keyword", type);
            } else if (kind == TOK_KEYWORD) {
                add_symbol(token, "Keyword", "-");
            } else if (kind == TOK_NUMBER) {
                add_symbol(token, "Number", "literal");
            } else {
                copy_text(type, sizeof(type), last_type[0] ? last_type : "-");
                add_symbol(token, "Identifier", type);
            }
            continue;
        }
        i++;
    }
}

static void print_table(void)
{
    printf("No  Identifier             Type       Category\n");
    printf("-----------------------------------------------\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%-3d %-21s %-10s %s\n", i + 1, table[i].name,
               table[i].type[0] ? table[i].type : "-", table[i].category);
    }
    printf("Total entries: %d\n", symbol_count);
}

int main(void)
{
    char line[MAX_LINE_LEN];
    char last_type[16] = "";
    int lines = 0;

    printf("Type C-like source code; press ENTER on an empty line to finish.\n");
    while (fgets(line, sizeof(line), stdin) != NULL) {
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }
        if (len == 0) break;
        process_line(line, last_type);
        lines++;
    }

    printf("Lines read: %d\n", lines);
    print_table();
    return 0;
}
