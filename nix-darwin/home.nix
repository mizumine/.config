{ user, nix-common, ... }:

{
  # importsを使って分割したファイルを読み込みます
  imports = [
    # Shared modules from nix-common
    nix-common.homeManagerModules.packages-base
    nix-common.homeManagerModules.rust-fenix
    nix-common.homeManagerModules.git
    nix-common.homeManagerModules.zsh
    nix-common.homeManagerModules.direnv

    # Darwin-specific modules
    ./modules/darwin-packages.nix
    ./modules/wezterm.nix
    ./modules/aerospace.nix
  ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true; 
}
