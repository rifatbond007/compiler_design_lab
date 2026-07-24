#!/usr/bin/env bash
# run.sh -- Lab 01 Identifier Validation
# Usage: ./run.sh [identifier]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PROGRAM="program"
cleanup() { rm -f "$PROGRAM"; }
trap cleanup EXIT

gcc -Wall -Wextra -std=c11 -O2 -o "$PROGRAM" program.c

if [ "$#" -ge 1 ]; then
    echo "$1" | ./"$PROGRAM"
else
    ./"$PROGRAM"
fi
