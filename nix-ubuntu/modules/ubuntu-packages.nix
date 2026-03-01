{ pkgs, gl, mkNixGLWrapper, ... }:

{
  home.packages = with pkgs; [
    # GUI applications (GL-wrapped)
    (mkNixGLWrapper gl wezterm)
    (mkNixGLWrapper gl obsidian)
    (mkNixGLWrapper gl firefox)
    (mkNixGLWrapper gl google-chrome)
    (mkNixGLWrapper gl bitwarden-desktop)
    (mkNixGLWrapper gl spotify)
    (mkNixGLWrapper gl nautilus)

    # Wayland utilities (GL-wrapped)
    (mkNixGLWrapper gl waybar)
    (mkNixGLWrapper gl wofi)
    (mkNixGLWrapper gl swaylock)

    # Wayland utilities (no GL needed)
    wl-clipboard
    grim
    slurp
    swayidle
    mako

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
