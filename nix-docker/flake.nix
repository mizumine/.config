{
  description = "nix-docker(linux)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-common.url = "path:../nix-common";
    nix-common.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-common, ... }:
    let
      # --- 設定変数の定義 ---
      user = "root";  # Dockerコンテナ内のユーザー
      gitName = "AI Agent";
      gitEmail = "example@example.com";
      system = "aarch64-linux"; # M4 Mac上のDocker用

      pkgs = nixpkgs.legacyPackages.${system};

      # CodeLLDBのラッパー定義
      codelldb-wrapper = pkgs.writeShellScriptBin "codelldb" ''
        exec "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb" "$@"
      '';
    in {
      formatter.${system} = pkgs.nixfmt-rfc-style;

      homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit gitName gitEmail;
        };

        modules = [
          # Shared modules from nix-common (NOT rust-fenix - uses rustup instead)
          nix-common.homeManagerModules.packages-base
          nix-common.homeManagerModules.git
          nix-common.homeManagerModules.zsh
          nix-common.homeManagerModules.direnv

          # Docker-specific configuration
          ({ pkgs, config, lib, ... }: {

            # --- ユーザー設定 ---
            home.username = user;
            home.homeDirectory = "/${user}";
            home.stateVersion = "24.05";

            home.sessionVariables = {
              LANG = "ja_JP.UTF-8";
              LC_ALL = "ja_JP.UTF-8";
              EDITOR = "nvim";
              SHELL = "${pkgs.zsh}/bin/zsh";
            };

            # --- Docker-specific packages ---
            home.packages = with pkgs; [
              # Runtime / Languages (rustup instead of fenix)
              nodejs_20
              mise
              rustup
              gcc

              # Debug
              codelldb-wrapper
            ];

            # --- プログラム設定 ---
            programs.home-manager.enable = true;

            # zellij設定 (Docker-specific keybinds to avoid conflict with host)
            programs.zellij = {
              enable = true;
              settings = {
                default_shell = "${pkgs.zsh}/bin/zsh";
                keybinds = {
                  normal = {
                    # コンテナ側のロック開始キーを Ctrl+b に変更
                    "bind \"Ctrl b\"" = { SwitchToMode = "Locked"; };
                    # デフォルトの Ctrl+g を無効化
                    "unbind \"Ctrl g\"" = {};
                  };
                  locked = {
                    # コンテナ側のロック解除キーを Ctrl+b に変更
                    "bind \"Ctrl b\"" = { SwitchToMode = "Normal"; };
                    # デフォルトの Ctrl+g を無効化
                    "unbind \"Ctrl g\"" = {};
                  };
                };
              };
            };

            # シンボリックリンク (Claude config sync)
            home.activation.syncClaudeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
              # -------------------------------------------------------
              # 設定: ~/.config/claude (Git管理) の中身を ~/.claude にリンクする
              # -------------------------------------------------------

              # パスの定義
              SOURCE_DIR="${config.home.homeDirectory}/.config/claude"
              TARGET_DIR="${config.home.homeDirectory}/.claude"

              # ソースディレクトリが存在する場合のみ実行
              if [ -d "$SOURCE_DIR" ]; then

                # ターゲットディレクトリがなければ作成（-p: 既にあれば何もしない）
                $DRY_RUN_CMD mkdir -p "$TARGET_DIR"

                # nullglob: マッチするファイルがない場合に *.xyz のままループしないようにする設定
                shopt -s nullglob

                # ループ処理: ソース内の全ファイルをターゲットにリンク
                for file in "$SOURCE_DIR"/*; do
                  filename=$(basename "$file")

                  # ln -sfn:
                  # -s: シンボリックリンク作成
                  # -f: 強制（同名ファイル/リンクがあれば上書き）
                  # -n: リンク先がディレクトリの場合の挙動を修正
                  $DRY_RUN_CMD ln -sfn "$file" "$TARGET_DIR/$filename"
                done

                # 設定を元に戻す
                shopt -u nullglob
              fi
            '';

          })
        ];
      };
    };
}
