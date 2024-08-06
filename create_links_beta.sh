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
    wget -qO- https://packagecloud.io/Tabby/release/gpgkey | sudo apt-key add -
    sudo sh -c 'echo "deb https://packagecloud.io/Tabby/release/ubuntu/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/tabby.list'
    sudo apt-get update
    sudo apt-get install -y tabby
  elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
    sudo rpm --import https://packagecloud.io/Tabby/release/gpgkey
    sudo sh -c 'echo -e "[tabby]\nname=Tabby\nbaseurl=https://packagecloud.io/Tabby/release/el/7/x86_64\ngpgcheck=1\nenabled=1\ngpgkey=https://packagecloud.io/Tabby/release/gpgkey" > /etc/yum.repos.d/tabby.repo'
    sudo dnf install -y tabby
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
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Gohu.zip"
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
  [".wezterm.lua"]="$HOME/.wezterm.lua"
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
