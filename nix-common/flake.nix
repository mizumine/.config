{
  description = "Shared Nix modules for dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rustowl = {
      url = "github:nix-community/rustowl-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fenix, rustowl }: {
    # Home Manager modules that can be imported
    homeManagerModules = {
      packages-base = import ./modules/packages/base.nix;
      rust-fenix = import ./modules/packages/rust-fenix.nix;
      git = import ./modules/programs/git.nix;
      zsh = import ./modules/programs/zsh.nix;
      direnv = import ./modules/programs/direnv.nix;
    };

    # Pass through fenix overlay
    overlays = {
      fenix = fenix.overlays.default;
    };

    # Pass through inputs for consumers
    inherit fenix rustowl;
  };
}
