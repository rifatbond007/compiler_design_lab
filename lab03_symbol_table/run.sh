#!/usr/bin/env bash
# ============================================================
# run.sh -- Lab 03 Symbol Table Generator
# ============================================================
# The program reads C-like source code interactively, line by
# line. Press ENTER on an empty line to generate the table.
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PROGRAM="program"
SRC="program.c"

cleanup() {
    rm -f "$PROGRAM"
}
trap cleanup EXIT

if ! command -v gcc >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} gcc is not installed. Run ../install.sh first."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Compiling $SRC ..."
if gcc -Wall -Wextra -std=c11 -O2 -o "$PROGRAM" "$SRC"; then
    echo -e "${GREEN}[OK]${NC} Compilation successful."
else
    echo -e "${RED}[ERROR]${NC} Compilation failed."
    exit 1
fi

echo -e "${CYAN}[INFO]${NC} Starting interactive symbol-table generator ..."
echo "----------------------------------------"
./"$PROGRAM"
echo "----------------------------------------"
echo -e "${GREEN}[DONE]${NC} Completed successfully."
