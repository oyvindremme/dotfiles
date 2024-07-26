#!/bin/bash

# Define the source and target paths
declare -A links=(
  [".wezterm"]="~/.wezterm"
  [".zshrc"]="~/.zshrc"
  ["better-vim.lua"]="~/.config/better-vim/better-vim.lua"
  ["starship.toml"]="~/.config/starship.toml"
)

# Create the symbolic links
for source in "${!links[@]}"; do
  target=${links[$source]}
  ln -sf "$(pwd)/$source" "$target"
  echo "Created link: $source -> $target"
done
