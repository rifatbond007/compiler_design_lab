#!/usr/bin/env bash
# run.sh -- top-level menu for Compiler Design Lab
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LABS=(
    "lab01_validate|Check Identifier"
    "lab02_count|Character Word Line Counter"
    "lab03_symbol|Generate Symbol Table"
    "lab04_tokens|Count Tokens"
    "lab05_words|Flex Word Counter"
    "lab06_classify|Flex Token Classifier"
    "lab07_comments|Flex Comment Checker"
    "lab08_expr|Bison Expression Validator"
    "lab09_palindrome|Bison Palindrome Checker"
    "lab10_calc|Lex + Yacc Calculator"
)

while true; do
    echo
    echo "=========================================="
    echo " Compiler Design Laboratory"
    echo "=========================================="
    for i in "${!LABS[@]}"; do
        IFS='|' read -r _ label <<<"${LABS[$i]}"
        printf " %2d. %s\n" $((i + 1)) "$label"
    done
    echo "  0. Exit"
    echo "=========================================="
    read -rp "Enter choice: " choice

    if [[ "$choice" == "0" || -z "$choice" ]]; then
        echo "Goodbye."
        exit 0
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#LABS[@]} )); then
        echo "Invalid choice."
        continue
    fi

    IFS='|' read -r folder _ <<<"${LABS[$((choice - 1))]}"
    if [[ ! -x "$folder/run.sh" ]]; then
        echo "Error: $folder/run.sh not found or not executable."
        continue
    fi

    echo
    echo "--- Running $folder ---"
    ( cd "$folder" && ./run.sh )
    echo "--- $folder finished ---"
done
