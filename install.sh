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

install_graphics_drivers() {
    info "Installing Intel graphics drivers..."
    paru -S --needed --noconfirm mesa vulkan-intel intel-media-driver
    success "Intel graphics drivers ready"
}

install_audio_stack() {
    info "Installing PipeWire audio stack..."
    paru -S --needed --noconfirm pipewire wireplumber pipewire-pulse pipewire-alsa pamixer

    info "Enabling PipeWire user services..."
    systemctl --user enable --now pipewire wireplumber pipewire-pulse

    success "PipeWire audio stack ready"
}

install_paru() {
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
}

setup_pacman_colors() {
    local pacman_conf="/etc/pacman.conf"

    info "Enabling pacman/paru colors..."

    if grep -q "^#Color" "$pacman_conf"; then
        sudo sed -i 's/^#Color/Color/' "$pacman_conf"
    elif ! grep -q "^Color" "$pacman_conf"; then
        sudo sed -i '/^\[options\]/a Color' "$pacman_conf"
    fi

    success "pacman/paru colors enabled"
}

install_xorg_picom() {
    info "Installing Xorg and picom..."
    paru -S --needed --noconfirm xorg-server xorg-xinit picom
    success "Xorg and picom ready"
}

setup_bashrc() {
    local script_dir="$(dirname "$(readlink -f "$0")")"

    info "Setting up ~/.bashrc..."
    cp "$script_dir/.bashrc" "$HOME/.bashrc"
    success "~/.bashrc ready"
}

setup_bash_profile() {
    local profile="$HOME/.bash_profile"
    local source_line='[[ -f ~/.bashrc ]] && . ~/.bashrc'
    local startx_line='[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &>/dev/null'

    info "Setting up ~/.bash_profile..."

    touch "$profile"

    if ! grep -qF '. ~/.bashrc' "$profile"; then
        printf '%s\n' "$source_line" >> "$profile"
    fi

    if ! grep -qF 'exec startx' "$profile"; then
        printf '%s\n' "$startx_line" >> "$profile"
    fi

    success "~/.bash_profile ready"
}

setup_gitconfig() {
    local script_dir="$(dirname "$(readlink -f "$0")")"

    info "Setting up ~/.gitconfig..."

    cp "$script_dir/.gitconfig" "$HOME/.gitconfig"

    success "~/.gitconfig ready"
}

setup_config_dir() {
    info "Setting up ~/.config directory..."
    mkdir -p ~/.config
    success "~/.config ready"
}

install_dwm() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local dwm_dir="$HOME/.config/dwm"

    info "Checking for dwm..."

    if command -v dwm >/dev/null 2>&1; then
        success "dwm is already installed"
        return
    fi

    if [[ -d "$dwm_dir" ]]; then
        warn "dwm directory already exists, pulling latest changes..."
        git -C "$dwm_dir" pull
    else
        info "Cloning dwm repository..."
        git clone https://git.suckless.org/dwm "$dwm_dir"
    fi

    info "Applying custom dwm config..."
    cp "$script_dir/dwm/config.h" "$dwm_dir/config.h"

    info "Building and installing dwm..."
    (
        cd "$dwm_dir"
        sudo make clean install
    )

    if command -v dwm >/dev/null 2>&1; then
        success "dwm installed successfully"
    else
        error "Could not install dwm. The dwm binary was not found after installation."
        exit 1
    fi
}

install_slstatus() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local slstatus_dir="$HOME/.config/slstatus"
    
    info "Checking for slstatus..."

    if command -v slstatus >/dev/null 2>&1; then
        success "slstatus is already installed"
        return
    fi

    if [[ -d "$slstatus_dir" ]]; then
        warn "slstatus directory already exists, pulling latest changes..."
        git -C "$slstatus_dir" pull
    else
        info "Cloning slstatus repository..."
        git clone https://git.suckless.org/slstatus "$slstatus_dir"
    fi

    info "Applying custom slstatus config..."
    cp "$script_dir/slstatus/config.h" "$slstatus_dir/config.h"

    info "Building and installing slstatus..."
    (
        cd "$slstatus_dir"
        sudo make clean install
    )

    if command -v slstatus >/dev/null 2>&1; then
        success "slstatus installed successfully"
    else
        error "Could not install slstatus. The slstatus binary was not found after installation."
        exit 1
    fi
}

install_apps() {
    info "Installing terminal, file manager and desktop apps..."
    paru -S --needed --noconfirm st alacritty nautilus google-chrome visual-studio-code-bin flameshot
    success "Applications installed successfully"
}

install_session_tools() {
    info "Installing session/lock tools..."
    paru -S --needed --noconfirm slock xss-lock xidlehook
    success "Session tools ready"
}

install_hardware_tools() {
    info "Installing hardware control tools..."
    paru -S --needed --noconfirm brightnessctl playerctl wireless_tools
    success "Hardware tools ready"
}

install_dev_runtimes() {
    info "Installing development runtimes..."
    paru -S --needed --noconfirm nodejs php
    success "Development runtimes ready"
}

install_cli_tools() {
    info "Installing CLI tools..."
    paru -S --needed --noconfirm fastfetch eza feh
    success "CLI tools ready"
}

install_theming() {
    info "Installing theming packages..."
    paru -S --needed --noconfirm bibata-cursor-theme
    success "Theming packages ready"
}

install_utilities() {
    install_session_tools
    install_hardware_tools
    install_dev_runtimes
    install_cli_tools
    install_theming
}

setup_alacritty() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local alacritty_dir="$HOME/.config/alacritty"

    info "Setting up Alacritty configuration..."

    mkdir -p "$alacritty_dir"

    cp "$script_dir/alacritty.toml" "$alacritty_dir/alacritty.toml"

    success "Alacritty configuration ready"
}

setup_picom() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local picom_dir="$HOME/.config/picom"

    info "Setting up picom configuration..."

    mkdir -p "$picom_dir"

    cp "$script_dir/picom.conf" "$picom_dir/picom.conf"

    success "picom configuration ready"
}

setup_xresources() {
    local xresources="$HOME/.Xresources"
    local cursor_line='Xcursor.theme: Bibata-Modern-Classic'

    info "Setting up ~/.Xresources..."

    touch "$xresources"

    if ! grep -qF 'Xcursor.theme' "$xresources"; then
        printf '%s\n' "$cursor_line" >> "$xresources"
    fi

    success "~/.Xresources ready"
}

setup_xinitrc() {
    info "Setting up ~/.xinitrc..."
    cp "$(dirname "$(readlink -f "$0")")/.xinitrc" "$HOME/.xinitrc"
    success "~/.xinitrc ready"
}

setup_wallpaper() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local wallpaper_dir="$HOME/.config"

    info "Setting up wallpaper..."

    cp "$script_dir/wallpaper.jpg" "$wallpaper_dir/wallpaper.jpg"

    success "Wallpaper ready"
}

setup_gtk_settings() {
    local gtk_dir="$HOME/.config/gtk-3.0"
    local settings_file="$gtk_dir/settings.ini"
    local font_line='gtk-font-name=Roboto 10'

    info "Setting up GTK settings..."

    mkdir -p "$gtk_dir"
    touch "$settings_file"

    if ! grep -qF '[Settings]' "$settings_file"; then
        printf '%s\n' '[Settings]' >> "$settings_file"
    fi

    if ! grep -qF 'gtk-font-name' "$settings_file"; then
        printf '%s\n' "$font_line" >> "$settings_file"
    fi

    success "GTK settings ready"
}

install_fonts() {
    info "Installing fonts..."
    paru -S --needed --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-roboto ttf-roboto-mono-nerd
    success "Fonts installed successfully"
}

reboot_system() {
    info "Installation complete. Rebooting system..."
    sleep 3
    sudo reboot
}

main() {
    install_paru
    setup_pacman_colors
    install_graphics_drivers
    install_audio_stack
    install_xorg_picom
    setup_bashrc
    setup_bash_profile
    setup_gitconfig
    setup_config_dir
    install_dwm
    install_slstatus
    install_apps
    install_utilities
    setup_alacritty
    setup_picom
    setup_xresources
    setup_xinitrc
    setup_wallpaper
    setup_gtk_settings
    install_fonts
    reboot_system
}

main "$@"
