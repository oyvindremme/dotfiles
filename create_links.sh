#!/bin/bash

# Install Zsh
if ! command -v zsh &> /dev/null; then
  echo "Installing Zsh..."
  sudo apt-get update && sudo apt-get install -y zsh
  chsh -s $(which zsh)
else
  echo "Zsh is already installed."
fi

# Install kitty
if ! command -v kitty &> /dev/null; then
  echo "Installing Kitty..."
  sudo apt-get update && sudo apt-get install -y kitty
else
  echo "Kitty is already installed."
fi

# Install fontconfig
if ! command -v fc-cache &> /dev/null; then
  echo "Installing fontconfig..."
  sudo apt update && sudo apt install -y fontconfig
else
  echo "fontconfig is already installed"
fi

# Install Nerd Font
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="Gohu"

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
  ["kitty.conf"]="$HOME/.config/kitty/kitty.conf"
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
