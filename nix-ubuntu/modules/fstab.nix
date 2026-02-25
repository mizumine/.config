{ config, lib, ... }:

{
  home.activation.manageFstab = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # NIXブロックの内容
    read -r -d "" NIX_BLOCK << 'EOF' || true
# BEGIN NIX MANAGED - DO NOT EDIT
/dev/disk/by-uuid/1d1a4191-8507-4c4a-bbfb-3b26d8e2d0fa  /mnt/nvme  xfs  defaults,noatime,nofail  0  2
# END NIX MANAGED
EOF

    # マウントポイントを作成
    if [ ! -d /mnt/nvme ]; then
      $DRY_RUN_CMD sudo mkdir -p /mnt/nvme
    fi

    # 既存のNIXブロックを削除して新しいものを追加
    $DRY_RUN_CMD sudo sed -i '/^# BEGIN NIX MANAGED/,/^# END NIX MANAGED/d' /etc/fstab
    echo "$NIX_BLOCK" | $DRY_RUN_CMD sudo tee -a /etc/fstab > /dev/null

    # 変更を反映
    $DRY_RUN_CMD sudo systemctl daemon-reload
  '';
}
