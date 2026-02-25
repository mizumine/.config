# nix-ubuntu Setup Guide

## Ubuntu再インストール後のnix-ubuntu設定適用手順

### 1. Ubuntuインストール

Ubuntu Desktop (24.04 LTS推奨) をインストール。ユーザー名は `settings-ubuntu.json` の `user` と一致させてください。

### 2. 必要なパッケージをインストール

```bash
sudo apt update
sudo apt install -y git curl xdg-user-dirs
xdg-user-dirs-update
```

### 3. Nixをインストール (Determinate Systems)

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

インストール後、シェルを再起動:
```bash
exec $SHELL
```

> **Note:** Determinate Systems版はFlakesがデフォルトで有効なため、`nix.conf` の設定は不要です。

### 4. dotfilesをクローン

```bash
git clone git@github.com:mizumine/.config.git ~/.config
```

### 5. 設定ファイルを作成

```bash
cat > ~/.config/nix/settings-ubuntu.json << 'EOF'
{
  "user": "mizumine",
  "gitName": "mizumine",
  "gitEmail": "your-email@example.com"
}
EOF
```

### 6. Home Managerを適用

```bash
cd ~/.config/nix-ubuntu
nix run home-manager/master -- switch --flake .#mizumine --impure
```

### 7. シェルを再起動

```bash
exec zsh
```

### 8. Swayを起動

TTYからログイン後:
```bash
sway
```

または、ディスプレイマネージャー (GDM/SDDM) でSwayセッションを選択。

---

## 補足

### NVMeマウントについて
`home-manager switch` 実行時にsudoパスワードが求められ、fstabが自動設定されます。

### 日本語入力
Sway起動後、`Caps Lock` または `Super+Space` で日本語入力に切り替え可能。

### トラブルシューティング
```bash
# Home Manager再適用
home-manager switch --flake ~/.config/nix-ubuntu#mizumine --impure

# Swayログ確認
journalctl --user -u sway
```
