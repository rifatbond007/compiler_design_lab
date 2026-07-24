#!/usr/bin/env bash
# install.sh -- one-shot dependency installer for Compiler Design Lab
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    SUDO=sudo
else
    SUDO=""
fi

echo "Updating package list..."
$SUDO apt update

echo "Installing gcc, flex, bison, make..."
$SUDO apt install -y gcc flex bison make

echo
echo "Verifying installed versions:"
printf "  gcc   : %s\n" "$(gcc --version | head -n1)"
printf "  flex  : %s\n" "$(flex --version)"
printf "  bison : %s\n" "$(bison --version | head -n1)"
printf "  make  : %s\n" "$(make --version | head -n1)"

echo
echo "All dependencies installed."
