{ pkgs, rustowl, system, ... }:

let
  codelldb-wrapper = pkgs.writeShellScriptBin "codelldb" ''
    exec "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb" "$@"
  '';
  toolchain = pkgs.fenix.stable;
in
{
  home.packages = with pkgs; [
    # Rust toolchain via fenix
    fenix.stable.cargo
    fenix.stable.rustc
    fenix.stable.rustfmt
    fenix.stable.clippy
    fenix.stable.rust-analyzer
    fenix.stable.rust-src

    # Rustowl for ownership visualization
    rustowl.packages.${system}.default

    # Debug adapter
    codelldb-wrapper
  ];

  # Required for rustowl
  home.sessionVariables = {
    RUST_SRC_PATH = "${toolchain.rust-src}/lib/rustlib/src/rust/library";
  };
}
