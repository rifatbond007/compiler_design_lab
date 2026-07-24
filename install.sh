#!/usr/bin/env bash
# install.sh -- cross-platform dependency installer for Compiler Design Lab
#
# Supports:
#   - Ubuntu / Debian / WSL (apt)
#   - Fedora / RHEL / CentOS (dnf / yum)
#   - Arch / Manjaro (pacman)
#   - Alpine (apk)
#   - macOS with Homebrew (brew)
#
# On Windows, run this from WSL (recommended) or Git Bash.

set -euo pipefail

echo "Detecting platform..."

case "$(uname -s)" in
    Linux*)
        if   command -v apt-get >/dev/null 2>&1; then PM="apt-get"
        elif command -v dnf     >/dev/null 2>&1; then PM="dnf"
        elif command -v yum     >/dev/null 2>&1; then PM="yum"
        elif command -v pacman  >/dev/null 2>&1; then PM="pacman"
        elif command -v apk     >/dev/null 2>&1; then PM="apk"
        else
            echo "Error: no supported package manager found (apt, dnf, yum, pacman, apk)."
            echo "Install gcc, flex, bison, make manually and re-run."
            exit 1
        fi
        OS="Linux ($PM)"
        ;;
    Darwin*)
        if ! command -v brew >/dev/null 2>&1; then
            echo "Error: Homebrew not found. Install it from https://brew.sh first."
            exit 1
        fi
        PM="brew"
        OS="macOS (Homebrew)"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "Windows native is not supported."
        echo "Please install WSL (Windows Subsystem for Linux) and run this script inside WSL."
        echo "  wsl --install"
        exit 1
        ;;
    *)
        echo "Error: unsupported platform '$(uname -s)'."
        exit 1
        ;;
esac

echo "Platform : $OS"
echo

case "$PM" in
    apt-get)
        SUDO=""
        [[ $EUID -ne 0 ]] && SUDO="sudo"
        $SUDO apt-get update
        $SUDO apt-get install -y gcc flex bison make
        ;;
    dnf|yum)
        SUDO=""
        [[ $EUID -ne 0 ]] && SUDO="sudo"
        $SUDO "$PM" install -y gcc flex bison make
        ;;
    pacman)
        SUDO=""
        [[ $EUID -ne 0 ]] && SUDO="sudo"
        $SUDO pacman -Sy --noconfirm gcc flex bison make
        ;;
    apk)
        SUDO=""
        [[ $EUID -ne 0 ]] && SUDO="sudo"
        $SUDO apk add gcc flex bison make musl-dev
        ;;
    brew)
        brew update
        brew install gcc flex bison make
        ;;
esac

echo
echo "Verifying installed versions:"

if command -v gcc >/dev/null 2>&1; then
    printf "  gcc   : %s\n" "$(gcc --version | head -n1)"
else
    echo "  gcc   : NOT FOUND"
fi
if command -v flex >/dev/null 2>&1; then
    printf "  flex  : %s\n" "$(flex --version)"
else
    echo "  flex  : NOT FOUND"
fi
if command -v bison >/dev/null 2>&1; then
    printf "  bison : %s\n" "$(bison --version | head -n1)"
else
    echo "  bison : NOT FOUND"
fi
if command -v make >/dev/null 2>&1; then
    printf "  make  : %s\n" "$(make --version | head -n1)"
else
    echo "  make  : NOT FOUND"
fi

echo
echo "All dependencies installed."
echo "Next step: chmod +x run.sh && ./run.sh"
