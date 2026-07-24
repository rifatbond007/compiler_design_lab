#!/usr/bin/env bash
# ============================================================
# run.sh -- Lab 08 Bison Expression Validator
# ============================================================
# Interactive: type arithmetic expressions line by line. Each
# ENTER validates the line just typed. Press ENTER on an empty
# line to finish.
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LEX_SRC="program.l"
YACC_SRC="program.y"
PROGRAM="program"
GENERATED_LEX="lex.yy.c"
GENERATED_YACC="y.tab.c"
GENERATED_YACC_H="y.tab.h"

cleanup() {
    rm -f "$PROGRAM" "$GENERATED_LEX" "$GENERATED_YACC" "$GENERATED_YACC_H"
}
trap cleanup EXIT

if ! command -v bison >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} bison is not installed. Run ../install.sh first."
    exit 1
fi
if ! command -v flex >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} flex is not installed. Run ../install.sh first."
    exit 1
fi
if ! command -v gcc >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} gcc is not installed. Run ../install.sh first."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Running bison on $YACC_SRC ..."
if ! bison -d -o "$GENERATED_YACC" "$YACC_SRC"; then
    echo -e "${RED}[ERROR]${NC} bison failed."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Running flex on $LEX_SRC ..."
if ! flex "$LEX_SRC"; then
    echo -e "${RED}[ERROR]${NC} flex failed."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Compiling generated parser and scanner with gcc ..."
if gcc -D_POSIX_C_SOURCE=200809L -Wall -Wextra -std=c11 -O2 \
        -Wno-unused-function -Wno-unused-parameter \
        -o "$PROGRAM" "$GENERATED_YACC" "$GENERATED_LEX"; then
    echo -e "${GREEN}[OK]${NC} Compilation successful."
else
    echo -e "${RED}[ERROR]${NC} Compilation failed."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Starting interactive expression validator ..."
echo "----------------------------------------"
./"$PROGRAM"
echo "----------------------------------------"
echo -e "${GREEN}[DONE]${NC} Completed successfully."