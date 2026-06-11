#!/bin/bash
################################################################################
# Dotfiles Installation Script
# 
# This script automates the setup of a new system with all required packages,
# terminal configurations, and development tools.
#
# Usage: bash install.sh
# or: curl https://raw.githubusercontent.com/Akshaj-Bisht/dotfiles/main/install.sh | bash
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

################################################################################
# System Detection
################################################################################

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
                echo "arch"
            elif [[ "$ID" == "ubuntu" || "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
                echo "ubuntu"
            else
                echo "unknown"
            fi
        else
            echo "unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

################################################################################
# Package Installation Functions
################################################################################

install_packages_arch() {
    log_info "Installing packages for Arch Linux..."
    
    local packages=(
        # Core utilities
        "git"
        "curl"
        "wget"
        "base-devel"
        
        # Shell
        "zsh"
        
        # Editors
        "neovim"
        "nano"
        
        # Terminal emulators
        "foot"
        "alacritty"
        
        # Tools
        "fzf"
        "zoxide"
        "ripgrep"
        "eza"
        "tree-sitter"
        "gcc"
        
        # Development
        "python"
        "rustup"
        "go"
        "nodejs"
        "npm"
        
        # Formatters
        "prettier"
        "stylua"
        "shfmt"
        
        # LSP servers (optional - Mason will install these)
        # "python-lsp-server"
    )
    
    # Update system
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
    
    # Install packages
    for pkg in "${packages[@]}"; do
        if ! pacman -Q "$pkg" > /dev/null 2>&1; then
            log_info "Installing $pkg..."
            sudo pacman -S "$pkg" --noconfirm > /dev/null 2>&1 && \
                log_success "Installed $pkg" || \
                log_warning "Failed to install $pkg (may already exist)"
        else
            log_success "$pkg already installed"
        fi
    done
}

install_packages_ubuntu() {
    log_info "Installing packages for Ubuntu/Debian..."
    
    local packages=(
        # Core utilities
        "git"
        "curl"
        "wget"
        "build-essential"
        
        # Shell
        "zsh"
        
        # Editors
        "neovim"
        "nano"
        
        # Terminal emulators
        "foot"
        "alacritty"
        
        # Tools
        "fzf"
        "ripgrep"
        "tree-sitter-cli"
        "gcc"
        "npm"
        
        # Development
        "python3"
        "python3-pip"
        "golang-go"
        "nodejs"
    )
    
    # Update system
    log_info "Updating system packages..."
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get upgrade -y > /dev/null 2>&1
    
    # Install packages
    for pkg in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii.*$pkg"; then
            log_info "Installing $pkg..."
            sudo apt-get install -y "$pkg" > /dev/null 2>&1 && \
                log_success "Installed $pkg" || \
                log_warning "Failed to install $pkg (may already exist)"
        else
            log_success "$pkg already installed"
        fi
    done
    
    # Install eza if not present
    if ! command -v eza &> /dev/null; then
        log_info "Installing eza..."
        cargo install eza 2>/dev/null || log_warning "Failed to install eza"
    fi
}

install_packages_macos() {
    log_info "Installing packages for macOS..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    local packages=(
        "git"
        "zsh"
        "neovim"
        "fzf"
        "zoxide"
        "ripgrep"
        "eza"
        "tree-sitter"
        "foot"
        "alacritty"
        "python"
        "rust"
        "go"
        "node"
        "prettier"
    )
    
    for pkg in "${packages[@]}"; do
        if ! brew list "$pkg" > /dev/null 2>&1; then
            log_info "Installing $pkg..."
            brew install "$pkg" > /dev/null 2>&1 && \
                log_success "Installed $pkg" || \
                log_warning "Failed to install $pkg"
        else
            log_success "$pkg already installed"
        fi
    done
}

################################################################################
# Dotfiles Setup
################################################################################

setup_dotfiles() {
    log_info "Setting up dotfiles..."
    
    local dotfiles_dir="$HOME/.dotfiles"
    local github_repo="https://github.com/Akshaj-Bisht/dotfiles.git"
    
    # Check if dotfiles already exist
    if [ -d "$dotfiles_dir" ]; then
        log_warning "Dotfiles already exist at $dotfiles_dir"
        log_info "Pulling latest changes..."
        /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" pull origin main
        log_success "Dotfiles updated"
        return
    fi
    
    # Clone bare repository
    log_info "Cloning dotfiles repository..."
    git clone --bare "$github_repo" "$dotfiles_dir"
    log_success "Cloned dotfiles repository"
    
    # Create alias function (add to shell rc files later)
    log_info "Creating dotfiles alias..."
    mkdir -p ~/.local/bin
    
    # Checkout files
    log_info "Checking out dotfiles..."
    if ! /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" checkout -q; then
        log_warning "Conflicts detected, backing up existing files..."
        mkdir -p ~/.config-backup
        /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" checkout 2>&1 | \
            grep "error:" | awk '{print $4}' | \
            xargs -I {} mv {} ~/.config-backup/ 2>/dev/null || true
        
        log_info "Retrying checkout..."
        /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" checkout -q
    fi
    log_success "Checked out dotfiles"
    
    # Configure git
    log_info "Configuring git..."
    /usr/bin/git --git-dir="$dotfiles_dir" --work-tree="$HOME" config status.showUntrackedFiles no
    log_success "Git configured"
}

################################################################################
# Post-Installation Setup
################################################################################

setup_shell() {
    log_info "Setting up shell..."
    
    local current_shell=$(echo $SHELL)
    local zsh_path=$(which zsh)
    
    if [ "$current_shell" != "$zsh_path" ]; then
        log_info "Changing default shell to zsh..."
        chsh -s "$zsh_path"
        log_success "Shell changed to zsh"
    else
        log_success "zsh is already the default shell"
    fi
}

setup_neovim() {
    log_info "Setting up Neovim..."
    
    # Verify nvim is installed
    if ! command -v nvim &> /dev/null; then
        log_error "Neovim not installed"
        return 1
    fi
    
    log_success "Neovim is installed"
    log_info "Note: LSP servers and Treesitter parsers will auto-install"
    log_info "       when you first open a file. This is normal!"
    
    # Create cache directory
    mkdir -p ~/.cache/zsh
    mkdir -p ~/.cache/nvim
    
    log_success "Neovim cache directories created"
}

setup_rustup() {
    log_info "Setting up Rust..."
    
    if command -v rustup &> /dev/null; then
        log_success "Rustup already installed"
        log_info "Updating Rust..."
        rustup update > /dev/null 2>&1
        log_success "Rust updated"
    else
        log_warning "Rustup not found, skipping Rust setup"
    fi
}

setup_node_packages() {
    log_info "Setting up Node.js global packages..."
    
    if ! command -v npm &> /dev/null; then
        log_warning "npm not found, skipping Node.js setup"
        return
    fi
    
    local npm_packages=(
        "npm"
        "yarn"
    )
    
    for pkg in "${npm_packages[@]}"; do
        if npm list -g "$pkg" > /dev/null 2>&1; then
            log_success "$pkg already installed"
        else
            log_info "Installing $pkg..."
            npm install -g "$pkg" > /dev/null 2>&1 && \
                log_success "Installed $pkg" || \
                log_warning "Failed to install $pkg"
        fi
    done
}

################################################################################
# Final Setup
################################################################################

print_summary() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ Installation Complete!${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. ${YELLOW}Restart your terminal${NC} or run:"
    echo "   ${BLUE}exec zsh${NC}"
    echo ""
    echo "2. ${YELLOW}Create the dotfiles alias${NC}:"
    echo "   The alias is in your ~/.config/zsh/aliases.zsh"
    echo "   You can use it after restarting: ${BLUE}dotfiles status${NC}"
    echo ""
    echo "3. ${YELLOW}First Neovim use${NC}:"
    echo "   Open any file: ${BLUE}nvim somefile.py${NC}"
    echo "   LSP and Treesitter will auto-install. Be patient on first run!"
    echo ""
    echo "4. ${YELLOW}Verify everything${NC}:"
    echo "   ${BLUE}nvim --version${NC}"
    echo "   ${BLUE}zsh --version${NC}"
    echo ""
    echo "Included configs:"
    echo "  • Zsh with performance optimizations"
    echo "  • Neovim with auto-install LSP/Treesitter"
    echo "  • Foot terminal emulator"
    echo "  • Alacritty terminal emulator"
    echo ""
    echo "Documentation:"
    echo "  See ~/README.md for detailed setup instructions"
    echo ""
}

print_error_summary() {
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}⚠ Installation completed with some issues${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Please check the messages above for details."
    echo "Some packages may need manual installation."
    echo ""
    echo "For more information, see: ~/README.md"
    echo ""
}

################################################################################
# Main Installation Flow
################################################################################

main() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          Dotfiles Installation & Setup Script             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Detect OS
    log_info "Detecting operating system..."
    OS=$(detect_os)
    
    case "$OS" in
        arch)
            log_success "Detected Arch Linux"
            ;;
        ubuntu)
            log_success "Detected Ubuntu/Debian"
            ;;
        macos)
            log_success "Detected macOS"
            ;;
        *)
            log_error "Unsupported OS or could not detect"
            exit 1
            ;;
    esac
    
    echo ""
    
    # Step 1: Install packages
    log_info "Step 1/4: Installing system packages..."
    echo ""
    case "$OS" in
        arch)
            install_packages_arch
            ;;
        ubuntu)
            install_packages_ubuntu
            ;;
        macos)
            install_packages_macos
            ;;
    esac
    log_success "Step 1 completed"
    echo ""
    
    # Step 2: Setup dotfiles
    log_info "Step 2/4: Setting up dotfiles repository..."
    echo ""
    setup_dotfiles
    log_success "Step 2 completed"
    echo ""
    
    # Step 3: Post-installation configuration
    log_info "Step 3/4: Configuring applications..."
    echo ""
    setup_shell
    setup_neovim
    setup_rustup
    setup_node_packages
    log_success "Step 3 completed"
    echo ""
    
    # Step 4: Verification
    log_info "Step 4/4: Verifying installation..."
    echo ""
    
    local errors=0
    
    # Check installed tools
    for tool in git zsh nvim fzf ripgrep; do
        if command -v "$tool" &> /dev/null; then
            log_success "$tool is installed"
        else
            log_warning "$tool is not installed"
            ((errors++))
        fi
    done
    
    log_success "Step 4 completed"
    echo ""
    
    # Print summary
    if [ $errors -eq 0 ]; then
        print_summary
    else
        print_error_summary
    fi
}

# Run main function
main "$@"
