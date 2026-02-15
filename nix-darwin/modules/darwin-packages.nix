{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GUI applications (macOS-only)
    wezterm
    obsidian

    # SketchyBar font
    sketchybar-app-font

    # Terminal tools
    zellij
    mosh

    # Runtime / Languages
    nodejs_24
    mise
  ];
}
