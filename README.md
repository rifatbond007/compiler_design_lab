# Compiler Design Lab

A complete university lab project covering lexical analysis and parsing using **C**, **Flex (Lex)**, **Bison (Yacc)**, **GCC**, and **Bash**.

Works on **Linux**, **macOS**, and **Windows (via WSL or Git Bash)**.

Each lab is self-contained, compiles with a single command, and runs interactively from the terminal.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Platform Support](#platform-support)
- [Folder Structure](#folder-structure)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Installation Per Platform](#installation-per-platform)
  - [Linux (Ubuntu / Debian)](#linux-ubuntu--debian)
  - [Linux (Fedora / RHEL / CentOS)](#linux-fedora--rhel--centos)
  - [Linux (Arch / Manjaro)](#linux-arch--manjaro)
  - [macOS](#macos)
  - [Windows (WSL — recommended)](#windows-wsl--recommended)
  - [Windows (Git Bash)](#windows-git-bash)
- [Compilation and Execution](#compilation-and-execution)
  - [Run All Labs from the Menu](#run-all-labs-from-the-menu)
  - [Run a Lab Independently](#run-a-lab-independently)
- [Lab List](#lab-list)
- [Troubleshooting](#troubleshooting)
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

## Platform Support

| Platform         | Status             | Notes                                      |
| ---------------- | ------------------ | ------------------------------------------ |
| Linux (Ubuntu)   | Fully supported    | Tested on 22.04, 24.04, 25.10              |
| Linux (Debian)   | Fully supported    | `apt-get` installer                        |
| Linux (Fedora)   | Fully supported    | `dnf` installer                            |
| Linux (Arch)     | Fully supported    | `pacman` installer                         |
| macOS            | Fully supported    | Requires Homebrew + Xcode Command Line Tools |
| Windows + WSL    | Fully supported    | Best Windows experience                    |
| Windows + Git Bash| Mostly supported  | Bison may need manual install              |
| Windows native   | Not supported      | Use WSL                                    |

---

## Folder Structure

```
compiler_design_lab/
├── README.md
├── install.sh                 # cross-platform dependency installer
├── run.sh                     # top-level menu for all labs
│
└── Lab/
    ├── lab01_validate/        # identifier validation (C)
    ├── lab02_count/           # character/word/line counter (C)
    ├── lab03_symbol/          # symbol table generator (C)
    ├── lab04_tokens/          # token counter (C)
    ├── lab05_words/           # flex word counter
    ├── lab06_classify/        # flex token classifier
    ├── lab07_comments/        # flex comment checker
    ├── lab08_expr/            # bison expression validator
    ├── lab09_palindrome/      # bison palindrome checker
    └── lab10_calc/            # lex + yacc calculator
```

Each lab folder contains:

- `program.c` **or** `program.l` / `program.y` — source code
- `run.sh` — compile-and-run script
- `sample_output.txt` — example output

Generated files (`lex.yy.c`, `y.tab.c`, `y.tab.h`, `program`) are produced at runtime and removed automatically when the program exits.

---

## Requirements

- **Bash 4+** (already preinstalled on Linux and macOS)
- **GCC** with C11 support
- **Flex 2.6+**
- **Bison 3.0+**
- **Make** (optional, only for users who want to extend)

`install.sh` installs all four tools automatically based on your operating system.

---

## Quick Start

On **any supported platform**:

```bash
git clone https://github.com/rifatbond007/compiler_design_lab.git
cd compiler_design_lab
chmod +x install.sh run.sh
./install.sh
./run.sh
```

The first script detects your OS, installs the build tools, and verifies them. The second script opens the lab menu.

To run a single lab directly:

```bash
cd lab05_words
./run.sh
```

---

## Installation Per Platform

If you prefer to install dependencies manually instead of running `install.sh`, follow the steps for your platform.

### Linux (Ubuntu / Debian)

```bash
sudo apt-get update
sudo apt-get install -y gcc flex bison make
```

Verified on Ubuntu 22.04, 24.04, 25.10 and Debian 12.

### Linux (Fedora / RHEL / CentOS)

```bash
sudo dnf install -y gcc flex bison make
```

On older RHEL / CentOS without `dnf`, use `yum` instead.

### Linux (Arch / Manjaro)

```bash
sudo pacman -Sy gcc flex bison make
```

### macOS

Install **Homebrew** first (if you don't have it): <https://brew.sh>

Then install **Xcode Command Line Tools** (provides a working `cc`):

```bash
xcode-select --install
```

Then install the build tools:

```bash
brew update
brew install gcc flex bison make
```

> Note: Apple's stock `clang` cannot build these labs because Flex and Bison emit GCC-specific code. The `brew install gcc` step is required.

### Windows (WSL — recommended)

WSL gives you a real Linux environment on Windows, so all labs work identically to Linux.

1. Open PowerShell as Administrator and run:

   ```powershell
   wsl --install
   ```

2. Restart your computer when prompted.
3. Open the **Ubuntu** app from the Start menu and let it finish first-time setup.
4. Inside the Ubuntu terminal:

   ```bash
   sudo apt-get update
   sudo apt-get install -y gcc flex bison make git
   ```

5. Clone and run:

   ```bash
   git clone https://github.com/rifatbond007/compiler_design_lab.git
   cd compiler_design_lab
   chmod +x install.sh run.sh
   ./run.sh
   ```

### Windows (Git Bash)

Git Bash provides a Bash shell and `gcc` (via MinGW) but **does not include `flex` or `bison` by default**.

Recommended path: use **WSL** instead (see above). If you must use Git Bash:

1. Install Git for Windows: <https://git-scm.com/download/win>
2. Install MinGW-w64 (provides `gcc` and `make`).
3. Install Flex and Bison binaries from <https://sourceforge.net/projects/winflexbison/> and put them on `PATH`.
4. Open **Git Bash**, `cd` into the cloned repo, and run:

   ```bash
   ./run.sh
   ```

If you see `flex: command not found` or `bison: command not found`, your `PATH` does not include their install location.

---

## Compilation and Execution

### Run All Labs from the Menu

```bash
./run.sh
```

Displays a numbered menu. Pick a lab number, the script enters that folder, runs its `run.sh`, then returns to the menu. Pick `0` to exit.

### Run a Lab Independently

```bash
cd Lab/lab05_words
./run.sh
```

Each `run.sh` follows the same three-step pattern: compile, run, clean up generated files.

To build a lab and run it with custom input via stdin:

```bash
printf 'hello world\n\n' | ./Lab/lab05_words/run.sh
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

## Troubleshooting

**`Permission denied` when running `./install.sh` or `./run.sh`**

Make them executable:

```bash
chmod +x install.sh run.sh
```

**`gcc: command not found`**

GCC is not installed or not on your `PATH`. Run `./install.sh` or follow the manual install steps for your platform.

**`flex: command not found` or `bison: command not found`**

Same as above. On Windows native or Git Bash, install WinFlexBison.

**`./run.sh` opens but my input does nothing**

The programs read line-by-line. Press **ENTER on an empty line** to finish input and see the output.

**`fileno` undeclared when compiling a flex lab on Linux**

This is fixed in every `run.sh` by passing `-D_POSIX_C_SOURCE=200809L`. If you are compiling manually, add the same flag:

```bash
gcc -D_POSIX_C_SOURCE=200809L ...
```

**`/bin/bash^M: bad interpreter` on Linux**

The script was edited on Windows and has CRLF line endings. Fix with:

```bash
sed -i 's/\r$//' install.sh run.sh lab*/run.sh
```

---

## Author

**riftbond007**
abdullah.al.rifat2239@gmail.com

---

## License

This project is provided for educational use as part of a Compiler Design university lab course.
