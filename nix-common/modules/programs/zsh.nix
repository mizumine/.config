{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # Powerlevel10k theme
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      # --- Powerlevel10k ---
      [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

      # --- Rust (Cargo) ---
      if [ -d "$HOME/.cargo/bin" ]; then
        export PATH="$HOME/.cargo/bin:$PATH"
      fi

      # --- Mise ---
      if command -v mise &> /dev/null; then
        eval "$(mise activate zsh)"
      fi

      # --- Local bin ---
      if [ -d "$HOME/.local/bin" ]; then
        export PATH="$HOME/.local/bin:$PATH"
      fi
    '';
  };
}
