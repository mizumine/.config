{ pkgs, rustowl, system, ... }:
let
  codelldb-wrapper = pkgs.writeShellScriptBin "codelldb" ''
    exec "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb" "$@"
  '';
  toolchain = pkgs.fenix.stable;
in
{
  home.packages = with pkgs; [
    ripgrep
    gh
    fd
    bat
    eza
    dust
    typos
    jq
    ast-grep
    fzf
    lazygit
    bottom
    gdu
    nodejs_24
    wezterm
    neovim
    visidata
    mise
    gitleaks
    pre-commit
    zellij
    mosh

    # Filer for terminal
    yazi
    zoxide
    resvg
    poppler
    ffmpeg

    # gui
    obsidian

    # sketchbar font
    sketchybar-app-font

    # rust tool chains
    fenix.stable.cargo
    fenix.stable.rustc
    fenix.stable.rustfmt
    fenix.stable.clippy
    fenix.stable.rust-analyzer
    fenix.stable.rust-src
    rustowl.packages.${system}.default

    # Debug
    codelldb-wrapper
  ];

  # Required to run rustowl
  home.sessionVariables = {
    RUST_SRC_PATH = "${toolchain.rust-src}/lib/rustlib/src/rust/library";
  };
}
