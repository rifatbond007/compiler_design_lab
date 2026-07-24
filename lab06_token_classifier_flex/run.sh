#!/usr/bin/env bash
# ============================================================
# run.sh -- Lab 06 Flex Token Classifier
# ============================================================
# Interactive: type C-like source code line by line, finish by
# pressing ENTER on an empty line. Flex generates lex.yy.c,
# gcc compiles it, and all generated files are cleaned up.
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LEX_SRC="program.l"
PROGRAM="program"
GENERATED="lex.yy.c"

cleanup() {
    rm -f "$PROGRAM" "$GENERATED"
}
trap cleanup EXIT

if ! command -v flex >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} flex is not installed. Run ../install.sh first."
    exit 1
fi
if ! command -v gcc >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} gcc is not installed. Run ../install.sh first."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Running flex on $LEX_SRC ..."
if ! flex "$LEX_SRC"; then
    echo -e "${RED}[ERROR]${NC} flex failed."
    exit 1
fi
if [[ ! -f "$GENERATED" ]]; then
    echo -e "${RED}[ERROR]${NC} flex did not generate $GENERATED."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Compiling generated scanner with gcc ..."
if gcc -D_POSIX_C_SOURCE=200809L -Wall -Wextra -std=c11 -O2 \
        -Wno-unused-function -o "$PROGRAM" "$GENERATED"; then
    echo -e "${GREEN}[OK]${NC} Compilation successful."
else
    echo -e "${RED}[ERROR]${NC} Compilation failed."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Starting interactive token classifier ..."
echo "----------------------------------------"
./"$PROGRAM"
echo "----------------------------------------"
echo -e "${GREEN}[DONE]${NC} Completed successfully."