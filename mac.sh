set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Homebrew packages
brew bundle --file ~/.config/Brewfile

# Apply dotfiles from dotfilesMACOS
print_info "Applying configs from dotfilesMACOS..."
stow dotfilesMACOS --dotfiles || {
    print_error "Failed to apply dotfilesMACOS"
    exit 1
}
print_info "dotfilesMACOS applied successfully"

# Apply dotfiles from dotfilesSHARE
print_info "Applying configs from dotfilesSHARE..."
stow dotfilesSHARE --dotfiles || {
    print_error "Failed to apply dotfilesSHARE"
    exit 1
}
print_info "dotfilesSHARE applied successfully"

print_info "Configuration setup completed successfully! 🎉"
print_info "You may need to restart your terminal or run 'source ~/.zshrc' to apply shell changes."

# apply tmux plugins
print_info "Applying tmux plugins..."
tmux new-session -d
tmux source ~/.config/tmux/tmux.conf || {
    print_error "Failed to apply tmux plugins"
    exit 1
}
print_info "tmux plugins applied successfully"
