/*
 * ============================================================
 * Lab 01 - Identifier Validation in C
 * ============================================================
 *
 * Description:
 *   Reads an identifier from standard input and validates it
 *   according to the C language naming rules.
 *
 * Rules for a valid C identifier:
 *   1. The first character must be an alphabet (A-Z or a-z)
 *      or an underscore (_).
 *   2. Subsequent characters may be alphabets, digits (0-9),
 *      or underscores (_).
 *   3. The identifier must not match a reserved C keyword.
 *   4. There must be no whitespace characters.
 *
 * Author: riftbond007
 * ============================================================
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* Maximum allowed identifier length per C standard (at least 31 supported). */
#define MAX_IDENTIFIER_LENGTH 31

/* List of C reserved keywords that cannot be used as identifiers. */
static const char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default", "do",
    "double", "else", "enum", "extern", "float", "for", "goto", "if",
    "int", "long", "register", "return", "short", "signed", "sizeof",
    "static", "struct", "switch", "typedef", "union", "unsigned", "void",
    "volatile", "while",
    /* C99 / C11 reserved keywords */
    "inline", "restrict", "_Bool", "_Complex", "_Imaginary",
    NULL
};

/*
 * Function: is_keyword
 * --------------------
 *   Checks whether the given string matches any reserved C keyword.
 *
 *   str: null-terminated identifier string
 *
 *   returns: 1 if it is a keyword, 0 otherwise
 */
int is_keyword(const char *str)
{
    int i;
    if (str == NULL) {
        return 0;
    }
    for (i = 0; keywords[i] != NULL; i++) {
        if (strcmp(str, keywords[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

/*
 * Function: validate_identifier
 * -----------------------------
 *   Validates a C identifier string according to the rules above.
 *
 *   identifier: null-terminated input string
 *
 *   returns: 1 if the identifier is valid, 0 if it is invalid
 */
int validate_identifier(const char *identifier)
{
    int i;

    /* Rule 0: identifier must not be empty. */
    if (identifier == NULL || identifier[0] == '\0') {
        return 0;
    }

    /* Rule 1: first character must be alphabet or underscore. */
    if (!(isalpha((unsigned char)identifier[0]) || identifier[0] == '_')) {
        return 0;
    }

    /* Rule 2: subsequent characters must be alphanumerics or underscores. */
    for (i = 1; identifier[i] != '\0'; i++) {
        if (!(isalnum((unsigned char)identifier[i]) || identifier[i] == '_')) {
            return 0;
        }
    }

    /* Rule 3: must not be a reserved keyword. */
    if (is_keyword(identifier)) {
        return 0;
    }

    /* Rule 4 (optional): enforce recommended length limit. */
    if ((int)strlen(identifier) > MAX_IDENTIFIER_LENGTH) {
        return 0;
    }

    /* All checks passed. */
    return 1;
}

/*
 * Function: read_line
 * -------------------
 *   Reads a full line from stdin, removing the trailing newline.
 *   Returns 1 on success, 0 on failure (EOF or empty buffer).
 */
int read_line(char *buffer, int size)
{
    if (fgets(buffer, size, stdin) == NULL) {
        return 0;
    }
    /* Strip trailing newline if present. */
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
        buffer[len - 1] = '\0';
    }
    return 1;
}

int main(void)
{
    char identifier[256];

    printf("=========================================\n");
    printf(" Lab 01 - C Identifier Validator\n");
    printf("=========================================\n");
    printf("Enter an identifier: ");

    /* Flush stdout so the prompt shows before waiting for input. */
    fflush(stdout);

    if (!read_line(identifier, sizeof(identifier))) {
        printf("[ERROR] No input received. Exiting.\n");
        return 1;
    }

    /* Reject identifiers that contain whitespace characters. */
    for (int i = 0; identifier[i] != '\0'; i++) {
        if (isspace((unsigned char)identifier[i])) {
            printf("[ERROR] Identifier must not contain whitespace.\n");
            return 1;
        }
    }

    if (validate_identifier(identifier)) {
        printf("[OK] \"%s\" is a VALID C identifier.\n", identifier);
        return 0;
    } else {
        printf("[FAIL] \"%s\" is NOT a valid C identifier.\n", identifier);
        return 0;
    }
}
