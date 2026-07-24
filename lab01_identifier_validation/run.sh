#!/usr/bin/env bash
# ============================================================
# run.sh -- Lab 01 Identifier Validation
# ============================================================
# This script compiles and runs the identifier validation
# program. It accepts an optional identifier as a command-line
# argument. If no argument is given, it reads from stdin.
# ============================================================

set -euo pipefail

# Color codes for terminal output.
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# Resolve the directory of this script so the program works
# regardless of where it is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PROGRAM="program"
SRC="program.c"

# 1. Verify GCC is installed.
if ! command -v gcc >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} gcc is not installed. Run ../install.sh first."
    exit 1
fi

# 2. Compile the program.
echo -e "${CYAN}[INFO]${NC} Compiling $SRC ..."
if gcc -Wall -Wextra -std=c11 -O2 -o "$PROGRAM" "$SRC"; then
    echo -e "${GREEN}[OK]${NC} Compilation successful."
else
    echo -e "${RED}[ERROR]${NC} Compilation failed."
    exit 1
fi

# 3. Run the program.
echo -e "${CYAN}[INFO]${NC} Running $PROGRAM ..."
echo "----------------------------------------"

if [ "$#" -ge 1 ]; then
    # Pass identifier as argument via stdin redirection.
    echo "$1" | ./"$PROGRAM"
else
    ./"$PROGRAM"
fi

# 4. Cleanup generated binary.
rm -f "$PROGRAM"
echo "----------------------------------------"
echo -e "${GREEN}[DONE]${NC} Completed successfully."
