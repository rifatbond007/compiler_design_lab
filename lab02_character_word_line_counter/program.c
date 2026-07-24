/*
 * Lab 02 - Character, Word, and Line Counter
 *
 * Reads text interactively, one line at a time, ending when the
 * user presses ENTER on an empty line. Then prints the totals.
 *
 * Author: riftbond007
 */

#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_LINE_LENGTH 4096

int main(void)
{
    char line[MAX_LINE_LENGTH];
    long char_count = 0, word_count = 0, line_count = 0;

    printf("Type text line by line; press ENTER on an empty line to finish.\n");

    while (fgets(line, sizeof(line), stdin) != NULL) {
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }
        if (len == 0) break;

        line_count++;
        int in_word = 0;
        for (size_t i = 0; i < len; i++) {
            char_count++;
            if (isspace((unsigned char)line[i])) {
                in_word = 0;
            } else if (!in_word) {
                word_count++;
                in_word = 1;
            }
        }
    }

    printf("Lines: %ld  Words: %ld  Characters: %ld\n",
           line_count, word_count, char_count);
    return 0;
}