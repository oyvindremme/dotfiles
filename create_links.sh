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

# Install alacritty
if ! command -v alacritty &> /dev/null; then
  echo "Installing Alacritty..."
  install_package alacritty
else
  echo "Alacritty is already installed."
fi

# Install fontconfig
if ! command -v fc-cache &> /dev/null; then
  echo "Installing fontconfig..."
  install_package fontconfig
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
  [".config/better-vim/better-vim.lua"]="$HOME/.config/better-vim/better-vim.lua"
  [".config/starship.toml"]="$HOME/.config/starship.toml"
  if ["$distro" == "Arch Linux"]; then
    [".config/hypr/hyprland.conf"]="$HOME/.config/hypr/hyprland.conf"
    [".config/hypr/hyprpaper.conf"]="$HOME/.config/hypr/hyprpaper.conf"
    [".config/hypr/hyprpaper.conf"]="$HOME/.config/hypr/hyprpaper.conf"
    [".config/waybar/config.jsonc"]="$HOME/.config/waybar/config.jsonc"
    [".config/waybar/launch.sh"]="$HOME/.config/waybar/launch.sh"
    [".config/waybar/module.json"]="$HOME/.config/waybar/module.json"
    [".config/waybar/style.css"]="$HOME/.config/waybar/style.css"
    [".config/waybar/themeswitcher.sh"]="$HOME/.config/waybar/themeswitcher.sh"
    [".config/waybar/toggle.sh"]="$HOME/.config/waybar/toggle.sh"
  else
    echo "Skipping hyprland configurations. Not running Arch Linux."
  fi
)

# Create necessary directories and symbolic links
for source in "${!links[@]}"; do
  target=${links[$source]}
  dir=$(dirname "$target")
  mkdir -p "$dir"
  ln -sf "$(pwd)/$source" "$target"
  echo "Created link: $source -> $target"
done

# Copy Tokyo image
cp $HOME/dotfiles/images/tokyo.jpg $HOME/Pictures

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
