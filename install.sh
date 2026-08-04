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

require_sudo() {
    info "Requesting administrator privileges..."

    sudo -v

    while true; do
        sudo -n true || true
        sleep 30
        kill -0 "$$" || exit
    done 2>/dev/null &

    success "Administrator privileges granted"
}

setup_boot() {
    local grub_linux="/etc/grub.d/10_linux"
    local grub_default="/etc/default/grub"

    info "Configuring boot settings..."

    info "Clearing login banner..."
    sudo truncate -s 0 /etc/issue

    info "Disabling GRUB loading messages..."
    sudo sed -i "/'\$(echo \"\$message\" | grub_quote)'/{/^[[:space:]]*#/!s/^/#/}" "$grub_linux"

    info "Setting GRUB timeout to 0 seconds..."
    sudo sed -Ei 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' "$grub_default"

    info "Setting GRUB kernel parameters..."
    sudo sed -Ei 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet systemd.show_status=false vt.global_cursor_default=0"/' "$grub_default"

    info "Generating GRUB configuration..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    success "Boot settings ready"
}

setup_autologin() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local systemd_dir="/etc/systemd/system/getty@tty1.service.d"

    info "Setting up TTY autologin..."

    sudo mkdir -p "$systemd_dir"
    sudo cp "$script_dir/getty@tty1.service.d/override.conf" \
        "$systemd_dir/override.conf"

    sudo systemctl daemon-reload

    success "TTY autologin ready"
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

setup_paru_sudoloop() {
    local paru_conf="/etc/paru.conf"

    info "Enabling paru SudoLoop..."

    if grep -q "^#SudoLoop" "$paru_conf"; then
        sudo sed -i 's/^#SudoLoop/SudoLoop/' "$paru_conf"
    elif ! grep -q "^SudoLoop" "$paru_conf"; then
        sudo sed -i '/^\[options\]/a SudoLoop' "$paru_conf"
    fi

    success "paru SudoLoop enabled"
}

setup_paru_skipreview() {
    local paru_conf="/etc/paru.conf"

    info "Enabling paru SkipReview..."

    if grep -q "^#SkipReview" "$paru_conf"; then
        sudo sed -i 's/^#SkipReview/SkipReview/' "$paru_conf"
    elif ! grep -q "^SkipReview" "$paru_conf"; then
        sudo sed -i '/^\[options\]/a SkipReview' "$paru_conf"
    fi

    success "paru SkipReview enabled"
}

pkgs_graphics=(mesa vulkan-intel intel-media-driver)
pkgs_audio=(pipewire wireplumber pipewire-pulse pipewire-alsa pamixer)
pkgs_xorg=(xorg-server xorg-xinit xorg-xinput picom)
pkgs_dwm_deps=(libxft libxinerama)
pkgs_apps=(st alacritty nautilus google-chrome visual-studio-code-bin flameshot copyq)
pkgs_session=(slock xss-lock xidlehook gnome-keyring)
pkgs_hardware=(brightnessctl playerctl wireless_tools)
pkgs_dev=(nodejs php)
pkgs_cli=(fastfetch eza bat less feh zenity)
pkgs_theming=(bibata-cursor-theme-bin)
pkgs_fonts=(noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-roboto ttf-roboto-mono-nerd)

install_packages() {
    info "The following will be installed: graphics drivers, audio stack, Xorg/picom, dwm build dependencies, applications, session/lock tools, hardware control tools, development runtimes, CLI tools, theming packages, and fonts"

    local all_packages=(
        "${pkgs_graphics[@]}"
        "${pkgs_audio[@]}"
        "${pkgs_xorg[@]}"
        "${pkgs_dwm_deps[@]}"
        "${pkgs_apps[@]}"
        "${pkgs_session[@]}"
        "${pkgs_hardware[@]}"
        "${pkgs_dev[@]}"
        "${pkgs_cli[@]}"
        "${pkgs_theming[@]}"
        "${pkgs_fonts[@]}"
    )

    info "Installing ${#all_packages[@]} packages in a single transaction..."
    paru -S --needed --noconfirm "${all_packages[@]}"

    success "${#all_packages[@]} packages installed successfully"
}

enable_audio_services() {
    info "Enabling PipeWire user services..."
    systemctl --user enable --now pipewire wireplumber pipewire-pulse
    success "PipeWire audio stack ready"
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

setup_documents_dir() {
    info "Setting up ~/Documents directory..."
    mkdir -p ~/Documents
    success "~/Documents ready"
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

    info "Applying fullgaps patch..."
    if grep -q 'gappx' "$dwm_dir/dwm.c"; then
        warn "fullgaps patch already applied, skipping..."
    else
        curl -fsSL https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.4.diff | \
            patch -p1 -d "$dwm_dir"
        success "fullgaps patch applied"
    fi

    info "Adding gaps support to monocle layout..."
    if grep -q 'm->wx + m->gappx, m->wy + m->gappx' "$dwm_dir/dwm.c"; then
        warn "monocle gaps already applied, skipping..."
    else
        sed -i 's/resize(c, m->wx, m->wy, m->ww - 2 \* c->bw, m->wh - 2 \* c->bw, 0);/resize(c, m->wx + m->gappx, m->wy + m->gappx, m->ww - 2 \* c->bw - 2 \* m->gappx, m->wh - 2 \* c->bw - 2 \* m->gappx, 0);/' "$dwm_dir/dwm.c"
        success "monocle gaps applied"
    fi

    info "Applying movestack patch..."
    if [[ -f "$dwm_dir/movestack.c" ]]; then
        warn "movestack patch already applied, skipping..."
    else
        curl -fsSL https://dwm.suckless.org/patches/movestack/dwm-movestack-20211115-a786211.diff | \
            patch -p1 -d "$dwm_dir" || true

        rm -f "$dwm_dir/config.def.h.rej"

        success "movestack patch applied"
    fi

    info "Applying tiledmove patch..."
    if grep -q 'recttomon(ev.xmotion.x_root' "$dwm_dir/dwm.c"; then
        warn "tiledmove patch already applied, skipping..."
    else
        curl -fsSL https://dwm.suckless.org/patches/tiledmove/dwm-tiledmove-20231210-b731.diff | \
            patch -p1 -d "$dwm_dir"
        success "tiledmove patch applied"
    fi

    info "Hiding left side of dwm bar..."
    grep -n 'drw_text(' "$dwm_dir/dwm.c" | grep -v 'stext' | grep -v '//' | cut -d: -f1 | \
        xargs -r -I{} sed -i '{}s|^|// |' "$dwm_dir/dwm.c"

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

setup_flameshot() {
    info "Setting up Flameshot configuration..."

    mkdir -p "$HOME/.config/flameshot"

    cat > "$HOME/.config/flameshot/flameshot.ini" << 'EOF'
[General]
useX11LegacyScreenshot=true
EOF

    success "Flameshot configuration ready"
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

    cp "$script_dir/wallpaper.bmp" "$wallpaper_dir/wallpaper.bmp"

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

move_minarch() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    local destination="$HOME/Documents/$(basename "$script_dir")"

    info "Moving MinArch to ~/Documents..."

    if [[ "$script_dir" == "$destination" ]]; then
        success "MinArch is already in ~/Documents"
        return
    fi

    mv "$script_dir" "$destination"
    success "MinArch moved to ~/Documents"
}

reboot_system() {
    info "Installation complete. Rebooting system..."
    sleep 3
    sudo reboot
}

main() {
    require_sudo
    setup_boot
    setup_autologin
    install_paru
    setup_pacman_colors
    setup_paru_sudoloop
    setup_paru_skipreview
    install_packages
    enable_audio_services
    setup_bashrc
    setup_bash_profile
    setup_gitconfig
    setup_config_dir
    setup_documents_dir
    install_dwm
    install_slstatus
    setup_flameshot
    setup_alacritty
    setup_picom
    setup_xresources
    setup_xinitrc
    setup_wallpaper
    setup_gtk_settings
    move_minarch
    reboot_system
}

main "$@"
