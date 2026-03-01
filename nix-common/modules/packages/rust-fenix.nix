{ pkgs, rustowl, system, ... }:

let
  codelldb-wrapper = pkgs.writeShellScriptBin "codelldb" ''
    exec "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb" "$@"
  '';

  # overlay経由の pkgs.fenix では packages.${system} は無いので、stable直下を使う
  toolchain = pkgs.fenix.stable.withComponents [
    "cargo"
    "rustc"
    "rustfmt"
    "clippy"
    "rust-analyzer"
    "rust-src"
  ];
in
{
  home.packages = [
    toolchain
    rustowl.packages.${system}.default
    codelldb-wrapper
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
  };
}
