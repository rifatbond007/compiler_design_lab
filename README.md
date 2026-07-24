# Compiler Design Lab

A complete university lab project covering lexical analysis and parsing using **C**, **Flex (Lex)**, **Bison (Yacc)**, **GCC**, and **Bash** on Ubuntu Linux.

Each lab is self-contained, compiles with a single command, and runs interactively from the terminal.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Folder Structure](#folder-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Compilation and Execution](#compilation-and-execution)
  - [Run All Labs from the Menu](#run-all-labs-from-the-menu)
  - [Run a Lab Independently](#run-a-lab-independently)
- [Lab List](#lab-list)
- [Author](#author)
- [License](#license)

---

## Project Overview

This project implements all 10 standard compiler-design lab exercises:

1. **Labs 01 - 04**: Pure C programs (identifier validation, character/word/line counting, symbol table, token counter).
2. **Labs 05 - 07**: Flex scanners (word counter, token classifier, comment checker).
3. **Labs 08 - 10**: Flex + Bison programs (expression validator, palindrome checker, calculator).

Every lab takes input interactively line-by-line. Press **ENTER on an empty line** to finish.

---

## Folder Structure

```
compiler_design_lab/
├── README.md
├── install.sh                 # one-shot installer
├── run.sh                     # top-level menu for all labs
│
├── lab01_validate/            # identifier validation (C)
├── lab02_count/               # character/word/line counter (C)
├── lab03_symbol/              # symbol table generator (C)
├── lab04_tokens/              # token counter (C)
├── lab05_words/               # flex word counter
├── lab06_classify/            # flex token classifier
├── lab07_comments/            # flex comment checker
├── lab08_expr/                # bison expression validator
├── lab09_palindrome/          # bison palindrome checker
└── lab10_calc/                # lex + yacc calculator
```

Each lab folder contains:

- `program.c` **or** `program.l` / `program.y` — source code
- `run.sh` — compile-and-run script
- `sample_output.txt` — example output

Generated files (`lex.yy.c`, `y.tab.c`, `y.tab.h`, `program`) are produced at runtime and removed automatically when the program exits.

---

## Requirements

- Ubuntu 22.04 / 24.04 / 25.10 (or any modern Linux with `apt`)
- Bash 4+
- GCC (with support for C11)
- Flex 2.6+
- Bison 3.0+

---

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/rifatbond007/compiler_design_lab.git
cd compiler_design_lab
chmod +x install.sh run.sh
./install.sh
```

`install.sh` updates your package list and installs `gcc`, `flex`, `bison`, and `make`, then verifies each tool is reachable on `PATH`.

If you prefer to install manually:

```bash
sudo apt update
sudo apt install -y gcc flex bison make
```

---

## Compilation and Execution

### Run All Labs from the Menu

```bash
./run.sh
```

Displays a numbered menu. Pick a lab number, the script enters that folder, runs its `run.sh`, then returns to the menu. Pick `0` to exit.

### Run a Lab Independently

```bash
cd lab05_words
./run.sh
```

Each `run.sh` follows the same three-step pattern: compile, run, clean up generated files.

To build a lab and run it with custom input via stdin:

```bash
printf 'hello world\n\n' | ./lab05_words/run.sh
```

---

## Lab List

| #   | Folder                | Topic                          | Tool        |
| --- | --------------------- | ------------------------------ | ----------- |
| 1   | `lab01_validate`      | Identifier validation          | C           |
| 2   | `lab02_count`         | Character / word / line count  | C           |
| 3   | `lab03_symbol`        | Symbol table generator         | C           |
| 4   | `lab04_tokens`        | Token counter                  | C           |
| 5   | `lab05_words`         | Word counter                   | Flex        |
| 6   | `lab06_classify`      | Token classifier               | Flex        |
| 7   | `lab07_comments`      | Comment checker                | Flex        |
| 8   | `lab08_expr`          | Expression validator           | Flex + Bison|
| 9   | `lab09_palindrome`    | Palindrome checker             | Flex + Bison|
| 10  | `lab10_calc`          | Lex + Yacc calculator          | Flex + Bison|

Detailed descriptions of each lab are in `instructions.txt`.

---

## Author

**riftbond007**
abdullah.al.rifat2239@gmail.com

---

## License

This project is provided for educational use as part of a Compiler Design university lab course.
