{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    vim
    neovim

    # Core utilities
    ripgrep
    fd
    bat
    eza
    dust
    typos
    jq
    fzf

    # Development tools
    gh
    ast-grep
    lazygit
    bottom
    gdu
    visidata
    gitleaks
    pre-commit

    # Filer for terminal (yazi dependencies)
    yazi
    zoxide
    resvg
    poppler
    ffmpeg
  ];
}
