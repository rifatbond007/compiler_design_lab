#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
PROGRAM=program
trap 'rm -f "$PROGRAM"' EXIT

gcc -Wall -Wextra -std=c11 -O2 -o "$PROGRAM" program.c
./"$PROGRAM"
