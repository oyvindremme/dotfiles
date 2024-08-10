#!/bin/bash

# Function to detect the package manager
detect_package_manager() {
  if command -v apt-get &> /dev/null; then
    echo "apt-get"
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  else
    echo "unsupported"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)

if [ "$PACKAGE_MANAGER" == "unsupported" ]; then
  echo "Unsupported package manager. This script only supports apt-get and dnf."
  exit 1
fi

# Install Zsh
if ! command -v zsh &> /dev/null; then
  echo "Installing Zsh..."
  if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    sudo apt-get update && sudo apt-get install -y zsh
  elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
    sudo dnf install -y zsh
  fi
  chsh -s $(which zsh)
else
  echo "Zsh is already installed."
fi

# Install Tabby
if ! command -v tabby &> /dev/null; then
  echo "Installing Tabby..."
  if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    wget "https://github.com/Eugeny/tabby/releases/download/v1.0.211/tabby-1.0.211-linux-x64.deb"
    sudo apt install -y ./tabby-1.0.211-linux-x64.deb
  elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
    wget "https://github.com/Eugeny/tabby/releases/download/v1.0.211/tabby-1.0.211-linux-x64.rpm"
    sudo dnf install -y ./tabby-1.0.211-linux-x64.rpm
  fi
else
  echo "Tabby is already installed."
fi

# Install fontconfig
if ! command -v fc-cache &> /dev/null; then
  echo "Installing fontconfig..."
  if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    sudo apt update && sudo apt install -y fontconfig
  elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
    sudo dnf install -y fontconfig
  fi
else
  echo "fontconfig is already installed"
fi

# Install Nerd Font
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="Hack"

echo "Downloading and installing $FONT_NAME Nerd Font..."
mkdir -p "$FONT_DIR"
wget "$NERD_FONT_URL" -O "$FONT_DIR/$FONT_NAME.zip"
unzip -o "$FONT_DIR/$FONT_NAME.zip" -d "$FONT_DIR"
rm "$FONT_DIR/$FONT_NAME.zip"

# Update font cache
echo "Updating font cache..."
fc-cache -fv

echo "$FONT_NAME Nerd Font installed successfully."

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
  ["better-vim.lua"]="$HOME/.config/better-vim/better-vim.lua"
  ["starship.toml"]="$HOME/.config/starship.toml"
)

# Create necessary directories and symbolic links
for source in "${!links[@]}"; do
  target=${links[$source]}
  dir=$(dirname "$target")
  mkdir -p "$dir"
  ln -sf "$(pwd)/$source" "$target"
  echo "Created link: $source -> $target"
done

echo "Installation and setup complete!"
