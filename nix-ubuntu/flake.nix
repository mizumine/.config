{
  description = "nix-ubuntu (x86_64-linux desktop)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-common.url = "path:../nix-common";
    nix-common.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-common, ... }:
    let
      system = "x86_64-linux";

      # Load settings from JSON file
      settings = builtins.fromJSON (builtins.readFile (builtins.getEnv "PWD" + "/../nix/settings-ubuntu.json"));
      user = settings.user;
      gitName = settings.gitName;
      gitEmail = settings.gitEmail;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nix-common.overlays.fenix ];
      };
    in {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit user system gitName gitEmail;
          rustowl = nix-common.rustowl;
        };

        modules = [
          # Shared modules from nix-common
          nix-common.homeManagerModules.packages-base
          nix-common.homeManagerModules.rust-fenix
          nix-common.homeManagerModules.git
          nix-common.homeManagerModules.zsh
          nix-common.homeManagerModules.direnv

          # Ubuntu-specific modules
          ./modules/ubuntu-packages.nix
          ./modules/wezterm.nix
          ./modules/sway.nix

          # Ubuntu-specific configuration
          ({ pkgs, config, lib, ... }: {
            home.username = user;
            home.homeDirectory = "/home/${user}";
            home.stateVersion = "24.05";

            home.sessionVariables = {
              LANG = "ja_JP.UTF-8";
              LC_ALL = "ja_JP.UTF-8";
              EDITOR = "nvim";
              SHELL = "${pkgs.zsh}/bin/zsh";
              # Wayland-specific
              MOZ_ENABLE_WAYLAND = "1";
              QT_QPA_PLATFORM = "wayland";
              SDL_VIDEODRIVER = "wayland";
              _JAVA_AWT_WM_NONREPARENTING = "1";
            };

            programs.home-manager.enable = true;

            # Zellij configuration
            programs.zellij = {
              enable = true;
              settings = {
                default_shell = "${pkgs.zsh}/bin/zsh";
              };
            };

            # Sync claude config
            home.activation.syncClaudeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
              SOURCE_DIR="${config.home.homeDirectory}/.config/claude"
              TARGET_DIR="${config.home.homeDirectory}/.claude"

              if [ -d "$SOURCE_DIR" ]; then
                $DRY_RUN_CMD mkdir -p "$TARGET_DIR"
                shopt -s nullglob
                for file in "$SOURCE_DIR"/*; do
                  filename=$(basename "$file")
                  $DRY_RUN_CMD ln -sfn "$file" "$TARGET_DIR/$filename"
                done
                shopt -u nullglob
              fi
            '';
          })
        ];
      };
    };
}
