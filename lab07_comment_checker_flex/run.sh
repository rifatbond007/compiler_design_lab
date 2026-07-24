#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
PROGRAM=program
GENERATED=lex.yy.c
trap 'rm -f "$PROGRAM" "$GENERATED"' EXIT

flex program.l
gcc -D_POSIX_C_SOURCE=200809L -Wall -Wextra -std=c11 -O2 -Wno-unused-function -o "$PROGRAM" "$GENERATED"
./"$PROGRAM"