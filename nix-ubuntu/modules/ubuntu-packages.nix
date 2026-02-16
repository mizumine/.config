{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI applications
    wezterm
    obsidian
    firefox
    google-chrome
    bitwarden-desktop
    spotify
    nautilus          # File manager (commander-one alternative)

    # Wayland utilities
    wl-clipboard    # Clipboard support for Wayland
    grim            # Screenshot utility
    slurp           # Region selection
    swaylock        # Screen locker
    swayidle        # Idle management
    waybar          # Status bar (like sketchybar)
    wofi            # Application launcher (like rofi for Wayland)
    mako            # Notification daemon

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack

    # Terminal tools
    zellij
    mosh

    # Runtime / Languages
    nodejs_24
    mise
    gcc
  ];

  # Enable fontconfig for user fonts
  fonts.fontconfig.enable = true;
}
