#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
PROGRAM=program
GENERATED_LEX=lex.yy.c
GENERATED_YACC=y.tab.c
GENERATED_YACC_H=y.tab.h
trap 'rm -f "$PROGRAM" "$GENERATED_LEX" "$GENERATED_YACC" "$GENERATED_YACC_H"' EXIT

bison -d -o "$GENERATED_YACC" program.y
flex program.l
gcc -D_POSIX_C_SOURCE=200809L -Wall -Wextra -std=c11 -O2 \
    -Wno-unused-function -Wno-unused-parameter \
    -o "$PROGRAM" "$GENERATED_YACC" "$GENERATED_LEX"
./"$PROGRAM"