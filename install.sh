#!/bin/bash
set -euo pipefail

if [[ -t 2 ]] && [[ -z "${NO_COLOR:-}" ]]; then
    BLUE=$'\e[0;34m'
    GREEN=$'\e[0;32m'
    YELLOW=$'\e[0;33m'
    RED=$'\e[0;31m'
    RESET=$'\e[0m'
else
    BLUE="" GREEN="" YELLOW="" RED="" RESET=""
fi

info()    { printf '%b==>%b %s\n' "$BLUE" "$RESET" "$*" >&2; }
success() { printf '%b✔%b %s\n' "$GREEN" "$RESET" "$*" >&2; }
warn()    { printf '%b!%b %s\n' "$YELLOW" "$RESET" "$*" >&2; }
error()   { printf '%b✘%b %s\n' "$RED" "$RESET" "$*" >&2; }

info "Checking for paru..."

if command -v paru >/dev/null 2>&1; then
    success "paru is already installed"
else
    info "paru not found, building from AUR..."
    sudo pacman -S --needed --noconfirm base-devel git

    info "Preparing build directory..."
    BUILD_DIR=$(mktemp -d)

    info "Cloning paru repository from AUR..."
    git clone --depth=1 https://aur.archlinux.org/paru.git "$BUILD_DIR"

    info "Building and installing paru..."
    (
        cd "$BUILD_DIR"
        makepkg -si --noconfirm
    )

    info "Cleaning up temporary files..."
    rm -rf "$BUILD_DIR"

    if command -v paru >/dev/null 2>&1; then
        success "paru installed successfully"
    else
        error "Could not install paru. The paru binary was not found after installation."
        exit 1
    fi
fi
