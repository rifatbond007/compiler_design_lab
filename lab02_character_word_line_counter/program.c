/*
 * ============================================================
 * Lab 02 - Character, Word, and Line Counter
 * ============================================================
 *
 * Description:
 *   Interactive program that asks the user to type text line by
 *   line, finishing when an empty line is entered. It then prints
 *   the total number of characters, words, and lines typed.
 *
 * Counting Rules:
 *   - Characters: every byte read (including spaces, tabs).
 *   - Lines:     number of non-empty lines entered by the user.
 *   - Words:     a maximal sequence of non-whitespace characters.
 *
 * Usage:
 *   ./program
 *
 * Author: riftbond007
 * ============================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define MAX_LINE_LENGTH 4096

int main(void)
{
    char line[MAX_LINE_LENGTH];

    long char_count = 0;
    long word_count = 0;
    long line_count = 0;

    printf("=========================================\n");
    printf(" Lab 02 - Character / Word / Line Counter\n");
    printf("=========================================\n");
    printf("Type your text line by line.\n");
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

        line_count++;

        /* Count characters and words in this line. */
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

    /* Display results. */
    printf("-----------------------------------------\n");
    printf("=========================================\n");
    printf(" Lab 02 - Character / Word / Line Counter\n");
    printf("=========================================\n");
    printf("Characters   : %ld\n", char_count);
    printf("Words        : %ld\n", word_count);
    printf("Lines        : %ld\n", line_count);
    printf("=========================================\n");

    return 0;
}
