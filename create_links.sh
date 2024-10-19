#!/bin/bash

distro=$(grep ^NAME= /etc/os-release | cut -d'=' -f2 | tr -d '"')

# Function to install a package using the appropriate package manager
install_package() {
  if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y "$1"
  elif command -v pacman &> /dev/null; then
    sudo pacman -Syu --noconfirm "$1"
  else
    echo "Unsupported package manager. Please install $1 manually."
    exit 1
  fi
}

# Prompt BetterVim API Key
echo "Enter your BetterVim API Key:"
read bvApiKey

# Install BetterVim
curl -L https://bettervim.com/install/$bvApiKey | bash

# Install Starship
if ! command -v starship &> /dev/null; then
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "Starship is already installed."
fi

# Define the source and target paths for configuration files
declare -A links=(
  [".zshrc"]="$HOME/.zshrc"
  [".config/better-vim/better-vim.lua"]="$HOME/.config/better-vim/better-vim.lua"
  [".config/starship.toml"]="$HOME/.config/starship.toml"
)

# Create necessary directories and symbolic links
for source in "${!links[@]}"; do
  target=${links[$source]}
  dir=$(dirname "$target")
  mkdir -p "$dir"
  ln -sf "$(pwd)/$source" "$target"
  echo "Created link: $source -> $target"
done

# Install Zsh
if ! command -v zsh &> /dev/null; then
  echo "Installing Zsh..."
  install_package zsh
  chsh -s $(which zsh)
else
  echo "Zsh is already installed."
fi

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installation and setup complete!"
