/*
 * ============================================================
 * Lab 03 - Symbol Table Generator
 * ============================================================
 *
 * Description:
 *   An interactive lexical analyzer. The user types C-like source
 *   code line by line, ending input by pressing Enter on an empty
 *   line. The program then builds and prints a symbol table.
 *
 * Recognized tokens:
 *   - Datatypes   (int, float, double, char, void, ...)
 *   - Keywords    (if, else, while, for, return, ...)
 *   - Identifiers
 *   - Numbers     (integer and floating-point literals)
 *
 *   Operators and separators are NOT stored in the symbol table
 *   because they are not user-defined names.
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

#define MAX_TOKEN_LEN     64
#define MAX_SYMBOLS       256
#define MAX_LINE_LEN      4096

/* ---------- Token categories ---------- */
typedef enum {
    TOK_DATATYPE,
    TOK_KEYWORD,
    TOK_IDENTIFIER,
    TOK_NUMBER
} TokenType;

/* ---------- Symbol-table entry ---------- */
typedef struct {
    char  name[64];
    char  type[16];      /* datatype for variables, "-" otherwise */
    char  category[16];  /* Keyword / Identifier / Number */
} Symbol;

/* ---------- Global state ---------- */
static Symbol table[MAX_SYMBOLS];
static int    symbol_count = 0;

/* ---------- C keyword list ---------- */
static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default",
    "do", "double", "else", "enum", "extern", "float", "for", "goto",
    "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union",
    "unsigned", "void", "volatile", "while",
    NULL
};

/* Datatypes are a subset of keywords. */
static const char *datatypes[] = {
    "int", "float", "double", "char", "void", "long", "short",
    "signed", "unsigned",
    NULL
};

/* ---------- Helper: bounded string copy ---------- */
static void copy_bounded(char *dest, const char *src, size_t dest_size)
{
    size_t i;
    for (i = 0; i + 1 < dest_size && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
}

/* ---------- Helper: string lookup ---------- */
static int in_list(const char *token, const char *list[])
{
    for (int i = 0; list[i] != NULL; i++) {
        if (strcmp(token, list[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

/* ---------- Helper: add to symbol table ---------- */
static void add_symbol(const char *name, const char *category, const char *type)
{
    /* Avoid duplicate entries by name. */
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(table[i].name, name) == 0) {
            return;
        }
    }
    if (symbol_count >= MAX_SYMBOLS) {
        return;
    }
    copy_bounded(table[symbol_count].name, name, sizeof(table[symbol_count].name));
    copy_bounded(table[symbol_count].type, type, sizeof(table[symbol_count].type));
    copy_bounded(table[symbol_count].category, category,
                 sizeof(table[symbol_count].category));
    symbol_count++;
}

/* ---------- Print the symbol table ---------- */
static void print_symbol_table(void)
{
    printf("+----+----------------------+----------+--------------+\n");
    printf("| %-2s | %-20s | %-8s | %-12s |\n",
           "No", "Identifier", "Type", "Category");
    printf("+----+----------------------+----------+--------------+\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("| %-2d | %-20s | %-8s | %-12s |\n",
               i + 1,
               table[i].name,
               table[i].type[0] ? table[i].type : "-",
               table[i].category);
    }
    printf("+----+----------------------+----------+--------------+\n");
    printf("Total entries: %d\n", symbol_count);
}

/* ---------- Classify a token ---------- */
static TokenType classify(const char *token)
{
    if (in_list(token, datatypes)) return TOK_DATATYPE;
    if (in_list(token, keywords))  return TOK_KEYWORD;

    /* Number if all characters are digits, with at most one '.' */
    int seen_dot = 0;
    for (size_t i = 0; token[i] != '\0'; i++) {
        if (token[i] == '.') {
            if (seen_dot) return TOK_IDENTIFIER;
            seen_dot = 1;
        } else if (!isdigit((unsigned char)token[i])) {
            return TOK_IDENTIFIER;
        }
    }
    return TOK_NUMBER;
}

/* ---------- Tokenize and build the table ---------- */
static void process_line(const char *line)
{
    char token[MAX_TOKEN_LEN];
    int  i = 0, t = 0;
    /* Note: last_datatype is process-global so datatype association
     * carries across multiple lines of typed input. */
    static char last_datatype[16] = "";

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

        /* Skip string/char literals completely. */
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

        /* Identifier / keyword / number: start with letter, underscore, or digit. */
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

            TokenType kind = classify(token);
            char dtype[16] = "";

            switch (kind) {
                case TOK_DATATYPE:
                    /* Remember last seen datatype for upcoming identifiers. */
                    copy_bounded(last_datatype, token, sizeof(last_datatype));
                    copy_bounded(dtype, token, sizeof(dtype));
                    add_symbol(token, "Keyword", dtype);
                    break;
                case TOK_KEYWORD:
                    add_symbol(token, "Keyword", dtype);
                    break;
                case TOK_NUMBER:
                    add_symbol(token, "Number", "literal");
                    break;
                case TOK_IDENTIFIER:
                default: {
                    const char *cat = "Identifier";
                    if (last_datatype[0] != '\0') {
                        copy_bounded(dtype, last_datatype, sizeof(dtype));
                    } else {
                        copy_bounded(dtype, "-", sizeof(dtype));
                    }
                    add_symbol(token, cat, dtype);
                    break;
                }
            }
            continue;
        }

        /* Skip operators and separators: they are NOT stored in the
         * symbol table because they are not user-defined names. */
        i++;
    }
}

int main(void)
{
    char line[MAX_LINE_LEN];
    int  line_no = 0;

    printf("=========================================\n");
    printf(" Lab 03 - Symbol Table Generator\n");
    printf("=========================================\n");
    printf("Type your C-like source code line by line.\n");
    printf("Press ENTER on an empty line to finish.\n");
    printf("-----------------------------------------\n");
    fflush(stdout);

    /* Interactive loop: read one line at a time.
     * The user signals "done" by pressing Enter on a blank line. */
    while (fgets(line, sizeof(line), stdin) != NULL) {
        /* Strip trailing newline (and optional carriage return). */
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }

        /* Empty line means the user is done. */
        if (len == 0) {
            break;
        }

        line_no++;
        process_line(line);
    }

    printf("-----------------------------------------\n");
    printf("=========================================\n");
    printf(" Lab 03 - Symbol Table Generator\n");
    printf("=========================================\n");
    printf("Lines read : %d\n", line_no);
    printf("=========================================\n");

    print_symbol_table();

    return 0;
}
