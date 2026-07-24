/*
 * Lab 01 - Identifier Validation in C
 *
 * Reads an identifier from standard input and validates it
 * according to the C language naming rules.
 *
 * Author: riftbond007
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_IDENTIFIER_LENGTH 31

static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default", "do",
    "double", "else", "enum", "extern", "float", "for", "goto", "if",
    "int", "long", "register", "return", "short", "signed", "sizeof",
    "static", "struct", "switch", "typedef", "union", "unsigned", "void",
    "volatile", "while",
    "inline", "restrict", "_Bool", "_Complex", "_Imaginary",
    NULL
};

static int is_keyword(const char *str)
{
    for (int i = 0; keywords[i] != NULL; i++) {
        if (strcmp(str, keywords[i]) == 0) return 1;
    }
    return 0;
}

static int validate_identifier(const char *identifier)
{
    if (identifier == NULL || identifier[0] == '\0') return 0;

    if (!(isalpha((unsigned char)identifier[0]) || identifier[0] == '_')) {
        return 0;
    }

    for (int i = 1; identifier[i] != '\0'; i++) {
        if (!(isalnum((unsigned char)identifier[i]) || identifier[i] == '_')) {
            return 0;
        }
    }

    if (is_keyword(identifier)) return 0;

    if ((int)strlen(identifier) > MAX_IDENTIFIER_LENGTH) return 0;

    return 1;
}

int main(int argc, char *argv[])
{
    char identifier[256];

    if (argc >= 2) {
        strncpy(identifier, argv[1], sizeof(identifier) - 1);
        identifier[sizeof(identifier) - 1] = '\0';
    } else {
        printf("Enter an identifier: ");
        fflush(stdout);
        if (fgets(identifier, sizeof(identifier), stdin) == NULL) {
            printf("No input received.\n");
            return 1;
        }
        size_t len = strlen(identifier);
        if (len > 0 && identifier[len - 1] == '\n') {
            identifier[len - 1] = '\0';
        }
    }

    for (int i = 0; identifier[i] != '\0'; i++) {
        if (isspace((unsigned char)identifier[i])) {
            printf("Error: identifier must not contain whitespace.\n");
            return 1;
        }
    }

    if (validate_identifier(identifier)) {
        printf("\"%s\" is a valid C identifier.\n", identifier);
    } else {
        printf("\"%s\" is NOT a valid C identifier.\n", identifier);
    }
    return 0;
}