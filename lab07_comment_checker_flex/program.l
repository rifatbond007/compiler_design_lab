/*
 * Lab 07 - Flex Comment Checker
 *
 * Reads C-like source code line by line and reports whether each
 * non-empty line is a comment, in a single line per input.
 *
 *   - "Single-line comment"   for "// ..."
 *   - "Block comment"         for "/* ... *\/" (possibly multi-line)
 *   - "Not a comment"         in any other case
 *
 * The block-comment state is preserved across lines so that a
 * block that opens on one line and closes on another is handled
 * correctly. Input ends when the user presses ENTER on an empty
 * line.
 *
 * Author: riftbond007
 */

%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>

static int  line_has_content = 0;
static int  line_is_comment  = 0;
static int  line_has_code    = 0;
static int  line_was_block   = 0;
static int  saw_line         = 0;
static int  in_block         = 0;

static long single_line_count = 0;
static long block_line_count  = 0;
static long not_comment_count = 0;

static void reset_line(void);
static void finish_line(void);
static void finish_at_eof(void);
%}

%x BLOCK_COMMENT SINGLE_COMMENT

%%

<INITIAL>"//"       {
                        line_has_content = 1;
                        line_is_comment  = 1;
                        BEGIN(SINGLE_COMMENT);
                    }

<INITIAL>"/*"       {
                        line_has_content = 1;
                        line_is_comment  = 1;
                        line_was_block   = 1;
                        in_block         = 1;
                        BEGIN(BLOCK_COMMENT);
                    }

<INITIAL>\n         {
                        if (!line_has_content) {
                            yyterminate();
                        }
                        finish_line();
                    }

<INITIAL>[ \t]+      { /* whitespace */ }

<INITIAL>.           {
                        line_has_content = 1;
                        line_has_code    = 1;
                    }

<SINGLE_COMMENT>[^\n]+ { /* rest of single-line comment */ }

<SINGLE_COMMENT>\n   {
                        line_has_content = 1;
                        finish_line();
                        BEGIN(INITIAL);
                    }

<BLOCK_COMMENT>"*/" {
                        in_block = 0;
                        BEGIN(INITIAL);
                    }

<BLOCK_COMMENT>"/*" { /* ignore nesting */ }

<BLOCK_COMMENT>\n   {
                        if (line_has_content) {
                            line_is_comment  = 1;
                            line_was_block   = 1;
                            finish_line();
                        }
                    }

<BLOCK_COMMENT>[^*\n]+ {
                        line_has_content = 1;
                        line_is_comment  = 1;
                        line_was_block   = 1;
                    }

<BLOCK_COMMENT>"*" {
                        line_has_content = 1;
                        line_is_comment  = 1;
                        line_was_block   = 1;
                    }

%%

static void reset_line(void)
{
    line_has_content = 0;
    line_is_comment  = 0;
    line_has_code    = 0;
    line_was_block   = 0;
}

static void finish_line(void)
{
    if (!line_has_content) {
        return;
    }

    saw_line = 1;
    if (line_is_comment && !line_has_code) {
        if (line_was_block) {
            printf("Block comment\n");
            block_line_count++;
        } else {
            printf("Single-line comment\n");
            single_line_count++;
        }
    } else {
        printf("Not a comment\n");
        not_comment_count++;
    }
    fflush(stdout);
    reset_line();
}

static void finish_at_eof(void)
{
    if (line_has_content) {
        finish_line();
    }
}

static void print_summary(void)
{
    long total = single_line_count + block_line_count + not_comment_count;
    printf("-----------------------------------------\n");
    printf("=========================================\n");
    printf(" Lab 07 - Flex Comment Checker\n");
    printf("=========================================\n");
    printf("Single-line comments : %ld\n", single_line_count);
    printf("Block comments       : %ld\n", block_line_count);
    printf("Not comments         : %ld\n", not_comment_count);
    printf("-----------------------------------------\n");
    printf("Total lines          : %ld\n", total);
    if (in_block) {
        printf("Warning              : unterminated block comment\n");
    }
    printf("=========================================\n");
}

int main(void)
{
    printf("=========================================\n");
    printf(" Lab 07 - Flex Comment Checker\n");
    printf("=========================================\n");
    printf("Type your C-like source code line by line.\n");
    printf("Each ENTER classifies the line just typed.\n");
    printf("Press ENTER on an empty line to finish.\n");
    printf("-----------------------------------------\n");
    fflush(stdout);

    yylex();
    finish_at_eof();
    print_summary();
    return EXIT_SUCCESS;
}

int yywrap(void)
{
    return 1;
}
