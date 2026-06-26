#!/usr/bin/env bash
################################################################################
# Dotfiles Installation Script
#
# Usage:
#   bash install.sh
#   bash install.sh --all
#   bash install.sh --select
#   bash install.sh --components zsh,doom,kitty,foot,mango
#   bash install.sh --list
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:Akshaj-Bisht/dotfiles.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

INSTALL_PACKAGES=1
INTERACTIVE=1
SELECTED_COMPONENTS=()

COMPONENTS=(
    "zsh"
    "nvim"
    "doom"
    "kitty"
    "foot"
    "niri"
    "mango"
    "dev"
)

log_info() {
    echo -e "${BLUE}i${NC} $1"
}

log_success() {
    echo -e "${GREEN}+${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

log_error() {
    echo -e "${RED}x${NC} $1"
}

usage() {
    cat <<EOF
Usage: bash install.sh [options]

Options:
  --all                         Install every component
  --select                      Prompt for components
  --components LIST             Install comma-separated components
                                Example: --components zsh,doom,kitty,foot
  --no-packages                 Only checkout/configure dotfiles, skip packages
  --list                        Show available components
  -h, --help                    Show this help

Components:
  zsh      Zsh config and shell helpers
  nvim     Neovim config
  doom     Doom Emacs user config
  kitty    Kitty terminal config
  foot     Foot terminal config
  niri     Niri config
  mango    MangoWM config, if present
  dev      Development tools and language runtimes
EOF
}

list_components() {
    printf '%s\n' "${COMPONENTS[@]}"
}

contains_component() {
    local wanted="$1"
    local component

    for component in "${SELECTED_COMPONENTS[@]}"; do
        [[ "$component" == "$wanted" ]] && return 0
    done

    return 1
}

valid_component() {
    local wanted="$1"
    local component

    for component in "${COMPONENTS[@]}"; do
        [[ "$component" == "$wanted" ]] && return 0
    done

    return 1
}

select_all_components() {
    SELECTED_COMPONENTS=("${COMPONENTS[@]}")
}

parse_component_list() {
    local raw="$1"
    local item

    SELECTED_COMPONENTS=()
    raw="${raw// /}"
    IFS=',' read -ra SELECTED_COMPONENTS <<< "$raw"

    for item in "${SELECTED_COMPONENTS[@]}"; do
        if [[ -z "$item" ]]; then
            log_error "Empty component in list: $raw"
            exit 1
        fi

        if ! valid_component "$item"; then
            log_error "Unknown component: $item"
            echo ""
            usage
            exit 1
        fi
    done
}

prompt_for_components() {
    local default="zsh,doom,kitty,foot,niri,mango"
    local input

    echo "Available components:"
    list_components | sed 's/^/  - /'
    echo ""
    read -r -p "Install components [all/$default]: " input

    input="${input:-$default}"
    if [[ "$input" == "all" ]]; then
        select_all_components
    else
        parse_component_list "$input"
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)
                INTERACTIVE=0
                select_all_components
                shift
                ;;
            --select)
                INTERACTIVE=1
                shift
                ;;
            --components)
                if [[ $# -lt 2 ]]; then
                    log_error "--components requires a comma-separated list"
                    exit 1
                fi
                INTERACTIVE=0
                parse_component_list "$2"
                shift 2
                ;;
            --no-packages)
                INSTALL_PACKAGES=0
                shift
                ;;
            --list)
                list_components
                exit 0
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                echo ""
                usage
                exit 1
                ;;
        esac
    done
}

detect_os() {
    if [[ "${OSTYPE:-}" == "linux-gnu"* ]]; then
        if [[ -f /etc/os-release ]]; then
            # shellcheck disable=SC1091
            . /etc/os-release
            if [[ "${ID:-}" == "arch" || "${ID_LIKE:-}" == *"arch"* ]]; then
                echo "arch"
            elif [[ "${ID:-}" == "ubuntu" || "${ID:-}" == "debian" || "${ID_LIKE:-}" == *"debian"* ]]; then
                echo "ubuntu"
            else
                echo "unknown"
            fi
        else
            echo "unknown"
        fi
    elif [[ "${OSTYPE:-}" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

dedupe_packages() {
    local seen=""
    local pkg

    for pkg in "$@"; do
        [[ " $seen " == *" $pkg "* ]] && continue
        seen="$seen $pkg"
        printf '%s\n' "$pkg"
    done
}

packages_for_arch() {
    local packages=(git curl wget)

    contains_component zsh && packages+=(zsh fzf zoxide eza)
    contains_component nvim && packages+=(neovim ripgrep tree-sitter gcc stylua shfmt prettier)
    contains_component doom && packages+=(emacs ripgrep fd)
    contains_component kitty && packages+=(kitty)
    contains_component foot && packages+=(foot)
    contains_component niri && packages+=(niri)
    contains_component dev && packages+=(base-devel gcc python rustup go nodejs npm)

    dedupe_packages "${packages[@]}"
}

packages_for_ubuntu() {
    local packages=(git curl wget)

    contains_component zsh && packages+=(zsh fzf ripgrep)
    contains_component nvim && packages+=(neovim ripgrep tree-sitter-cli gcc npm)
    contains_component doom && packages+=(emacs ripgrep fd-find)
    contains_component kitty && packages+=(kitty)
    contains_component foot && packages+=(foot)
    contains_component dev && packages+=(build-essential gcc python3 python3-pip golang-go nodejs npm)

    dedupe_packages "${packages[@]}"
}

packages_for_macos() {
    local packages=(git curl wget)

    contains_component zsh && packages+=(zsh fzf zoxide eza)
    contains_component nvim && packages+=(neovim ripgrep tree-sitter stylua shfmt prettier)
    contains_component doom && packages+=(emacs ripgrep fd)
    contains_component kitty && packages+=(kitty)
    contains_component dev && packages+=(python rust go node npm)

    dedupe_packages "${packages[@]}"
}

install_packages_arch() {
    local packages=("$@")
    local pkg

    [[ "${#packages[@]}" -eq 0 ]] && return

    log_info "Updating Arch package database..."
    sudo pacman -Syu --noconfirm

    for pkg in "${packages[@]}"; do
        if pacman -Q "$pkg" >/dev/null 2>&1; then
            log_success "$pkg already installed"
            continue
        fi

        log_info "Installing $pkg..."
        sudo pacman -S "$pkg" --noconfirm && log_success "Installed $pkg" || log_warning "Failed to install $pkg"
    done
}

install_packages_ubuntu() {
    local packages=("$@")
    local pkg

    [[ "${#packages[@]}" -eq 0 ]] && return

    log_info "Updating apt package database..."
    sudo apt-get update

    for pkg in "${packages[@]}"; do
        if dpkg -s "$pkg" >/dev/null 2>&1; then
            log_success "$pkg already installed"
            continue
        fi

        log_info "Installing $pkg..."
        sudo apt-get install -y "$pkg" && log_success "Installed $pkg" || log_warning "Failed to install $pkg"
    done
}

install_packages_macos() {
    local packages=("$@")
    local pkg

    [[ "${#packages[@]}" -eq 0 ]] && return

    if ! command -v brew >/dev/null 2>&1; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    for pkg in "${packages[@]}"; do
        if brew list "$pkg" >/dev/null 2>&1; then
            log_success "$pkg already installed"
            continue
        fi

        log_info "Installing $pkg..."
        brew install "$pkg" && log_success "Installed $pkg" || log_warning "Failed to install $pkg"
    done
}

install_selected_packages() {
    local os="$1"
    local packages=()

    if [[ "$INSTALL_PACKAGES" -eq 0 ]]; then
        log_warning "Skipping package installation"
        return
    fi

    case "$os" in
        arch)
            while IFS= read -r package; do
                packages+=("$package")
            done < <(packages_for_arch)
            install_packages_arch "${packages[@]}"
            ;;
        ubuntu)
            while IFS= read -r package; do
                packages+=("$package")
            done < <(packages_for_ubuntu)
            install_packages_ubuntu "${packages[@]}"
            ;;
        macos)
            while IFS= read -r package; do
                packages+=("$package")
            done < <(packages_for_macos)
            install_packages_macos "${packages[@]}"
            ;;
    esac
}

component_paths() {
    contains_component zsh && printf '%s\n' ".config/zsh" ".zshenv"
    contains_component nvim && printf '%s\n' ".config/nvim"
    contains_component doom && printf '%s\n' ".config/doom"
    contains_component kitty && printf '%s\n' ".config/kitty"
    contains_component foot && printf '%s\n' ".config/foot"
    contains_component niri && printf '%s\n' ".config/niri"
    contains_component mango && printf '%s\n' ".config/mango"
}

dotfiles_git() {
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

ensure_dotfiles_repo() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_info "Updating dotfiles repo at $DOTFILES_DIR..."
        dotfiles_git fetch origin "$DOTFILES_BRANCH"
        return
    fi

    log_info "Cloning dotfiles repo into $DOTFILES_DIR..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
}

backup_path() {
    local path="$1"
    local backup_dir="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"

    [[ -e "$HOME/$path" ]] || return

    mkdir -p "$backup_dir/$(dirname "$path")"
    mv "$HOME/$path" "$backup_dir/$path"
    log_warning "Backed up $path to $backup_dir/$path"
}

checkout_path() {
    local path="$1"

    if ! dotfiles_git checkout "$DOTFILES_BRANCH" -- "$path" 2>/tmp/dotfiles-checkout-error; then
        backup_path "$path"
        dotfiles_git checkout "$DOTFILES_BRANCH" -- "$path"
    fi
}

setup_dotfiles() {
    local paths=()
    local path

    log_info "Setting up selected dotfiles..."
    ensure_dotfiles_repo

    while IFS= read -r path; do
        paths+=("$path")
    done < <(component_paths)

    if [[ "${#paths[@]}" -eq 0 ]]; then
        log_warning "No dotfile paths selected"
    else
        for path in "${paths[@]}"; do
            if dotfiles_git ls-tree -r --name-only "$DOTFILES_BRANCH" -- "$path" | grep -q .; then
                checkout_path "$path"
                log_success "Checked out $path"
            else
                log_warning "$path is not tracked in the dotfiles repo; skipping"
            fi
        done
    fi

    dotfiles_git config status.showUntrackedFiles no
    mkdir -p "$HOME/.config/zsh"

    if ! grep -qs "alias dotfiles=" "$HOME/.config/zsh/aliases.zsh"; then
        printf "\nalias dotfiles='/usr/bin/git --git-dir=\$HOME/dotfiles --work-tree=\$HOME'\n" >> "$HOME/.config/zsh/aliases.zsh"
        log_success "Added dotfiles alias"
    else
        log_success "dotfiles alias already configured"
    fi
}

setup_shell() {
    local zsh_path

    contains_component zsh || return

    log_info "Setting up zsh..."
    if ! command -v zsh >/dev/null 2>&1; then
        log_warning "zsh is not installed"
        return
    fi

    zsh_path="$(command -v zsh)"
    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
        chsh -s "$zsh_path" || log_warning "Could not change default shell"
    fi
}

setup_neovim() {
    contains_component nvim || return

    log_info "Setting up Neovim..."
    mkdir -p "$HOME/.cache/nvim"

    if command -v nvim >/dev/null 2>&1; then
        log_success "Neovim is available"
    else
        log_warning "Neovim is not installed"
    fi
}

setup_doom() {
    contains_component doom || return

    log_info "Setting up Doom Emacs..."
    mkdir -p "$HOME/.config/doom"

    if [[ ! -x "$HOME/.config/emacs/bin/doom" ]]; then
        if [[ -e "$HOME/.config/emacs" ]]; then
            log_warning "~/.config/emacs exists but Doom was not found there"
            return
        fi

        log_info "Cloning Doom Emacs..."
        git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs" || {
            log_warning "Could not clone Doom Emacs"
            return
        }
    fi

    log_info "Running doom sync..."
    "$HOME/.config/emacs/bin/doom" sync || log_warning "doom sync failed"
}

setup_rustup() {
    contains_component dev || return

    if command -v rustup >/dev/null 2>&1; then
        log_info "Updating Rust toolchain..."
        rustup update || log_warning "rustup update failed"
    fi
}

setup_node_packages() {
    contains_component dev || contains_component nvim || return

    if ! command -v npm >/dev/null 2>&1; then
        log_warning "npm not found, skipping global Node packages"
        return
    fi

    if ! npm list -g yarn >/dev/null 2>&1; then
        log_info "Installing yarn..."
        npm install -g yarn || log_warning "Failed to install yarn"
    fi
}

verify_selection() {
    local errors=0
    local tool

    contains_component zsh && for tool in zsh git; do
        command -v "$tool" >/dev/null 2>&1 && log_success "$tool is installed" || { log_warning "$tool is not installed"; ((errors++)); }
    done

    contains_component nvim && {
        command -v nvim >/dev/null 2>&1 && log_success "nvim is installed" || { log_warning "nvim is not installed"; ((errors++)); }
    }

    contains_component doom && {
        command -v emacs >/dev/null 2>&1 && log_success "emacs is installed" || { log_warning "emacs is not installed"; ((errors++)); }
    }

    contains_component kitty && {
        command -v kitty >/dev/null 2>&1 && log_success "kitty is installed" || log_warning "kitty is not installed"
    }

    contains_component foot && {
        command -v foot >/dev/null 2>&1 && log_success "foot is installed" || log_warning "foot is not installed"
    }

    return "$errors"
}

print_summary() {
    echo ""
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${GREEN}Installation complete${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo ""
    echo "Selected components: ${SELECTED_COMPONENTS[*]}"
    echo ""
    echo "Useful commands:"
    echo "  exec zsh"
    echo "  dotfiles status"
    echo "  bash install.sh --components doom,kitty,foot"
    echo ""
}

main() {
    local os

    parse_args "$@"

    echo -e "${BLUE}Dotfiles Installation & Setup${NC}"
    echo ""

    if [[ "${#SELECTED_COMPONENTS[@]}" -eq 0 ]]; then
        if [[ "$INTERACTIVE" -eq 1 && -t 0 ]]; then
            prompt_for_components
        else
            select_all_components
        fi
    fi

    log_info "Selected components: ${SELECTED_COMPONENTS[*]}"

    os="$(detect_os)"
    case "$os" in
        arch|ubuntu|macos)
            log_success "Detected $os"
            ;;
        *)
            log_error "Unsupported OS or could not detect"
            exit 1
            ;;
    esac

    install_selected_packages "$os"
    setup_dotfiles
    setup_shell
    setup_neovim
    setup_doom
    setup_rustup
    setup_node_packages

    if verify_selection; then
        print_summary
    else
        log_warning "Finished with warnings"
        print_summary
    fi
}

main "$@"
