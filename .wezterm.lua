local wezterm = require 'wezterm';

return {
  enable_wayland = true,
  keys = {
    -- Resize pane
    {key="H", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 1}}},
    {key="L", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 1}}},
    {key="K", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
    {key="J", mods="CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
    -- Move to the pane on the right
    {key="L", mods="CTRL|SHIFT|ALT", action=wezterm.action{ActivatePaneDirection="Right"}},
    -- Move to the pane on the left
    {key="H", mods="CTRL|SHIFT|ALT", action=wezterm.action{ActivatePaneDirection="Left"}},
    -- Move to the pane above
    {key="K", mods="CTRL|SHIFT|ALT", action=wezterm.action{ActivatePaneDirection="Up"}},
    -- Move to the pane below
    {key="J", mods="CTRL|SHIFT|ALT", action=wezterm.action{ActivatePaneDirection="Down"}},
    {key="w", mods="CTRL", action=wezterm.action.CloseCurrentPane { confirm = true }}
  },
}
