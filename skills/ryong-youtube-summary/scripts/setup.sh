#!/usr/bin/env bash
set -euo pipefail

if command -v python3 >/dev/null 2>&1; then
  echo "python3 found: $(python3 --version 2>&1)"
else
  echo "python3 is required but not found."
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Install Python 3 with: brew install python"
  else
    echo "Install Python 3 with your package manager before continuing."
  fi
  exit 1
fi

OS="$(uname -s)"
if command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp already installed: $(yt-dlp --version)"
  exit 0
fi

if [[ "$OS" == "Darwin" ]]; then
  if command -v brew >/dev/null 2>&1; then
    brew install yt-dlp
    echo "Installed yt-dlp via Homebrew."
  else
    echo "Homebrew not found. Install Homebrew first: https://brew.sh"
    exit 1
  fi
elif [[ "$OS" == "Linux" ]]; then
  if command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y yt-dlp
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y yt-dlp
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm yt-dlp
  else
    echo "Unsupported Linux package manager. Install yt-dlp manually."
    exit 1
  fi
  echo "Installed yt-dlp on Linux."
else
  echo "Unsupported OS for this script. Use setup.ps1 on Windows."
  exit 1
fi
