{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.automatically_reload_config = true
      config.window_background_opacity = 0.9
      config.default_prog = { "${pkgs.zellij}/bin/zellij" }

      -- Decoration settings
      config.enable_tab_bar = false
      config.window_decorations = "RESIZE"

      -- Font settings
      config.font = wezterm.font('JetBrainsMono Nerd Font')
      config.font_size = 12.0

      -- Linux keybindings (using Super key instead of CMD)
      config.keys = {
        { key = 'h', mods = 'SUPER', action = act.SendKey { key = 'h', mods = 'ALT' } },
        { key = 'j', mods = 'SUPER', action = act.SendKey { key = 'j', mods = 'ALT' } },
        { key = 'k', mods = 'SUPER', action = act.SendKey { key = 'k', mods = 'ALT' } },
        { key = 'l', mods = 'SUPER', action = act.SendKey { key = 'l', mods = 'ALT' } },
        { key = 'n', mods = 'SUPER', action = act.SendKey { key = 'n', mods = 'ALT' } },
        { key = 't', mods = 'SUPER', action = act.SendKey { key = 't', mods = 'ALT' } },
        -- Copy/Paste with Super key
        { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
        { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
      }

      return config
    '';
  };
}
