{ pkgs, config, ... }:

{
  # Fcitx5 packages
  home.packages = with pkgs; [
    fcitx5
    fcitx5-mozc
    fcitx5-gtk
    # fcitx5-qt
    libsForQt5.fcitx5-qt
    # fcitx5-configtool
    qt6Packages.fcitx5-configtool
  ];

  # Input method environment variables
  home.sessionVariables = {
    # Fcitx5 settings for Wayland
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
    GLFW_IM_MODULE = "ibus";  # Some apps need this fallback
  };

  # Fcitx5 configuration
  xdg.configFile = {
    # Profile configuration
    "fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=mozc

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=mozc
      Layout=

      [GroupOrder]
      0=Default
    '';

    # Fcitx5 settings
    "fcitx5/config".text = ''
      [Hotkey]
      EnumerateWithTriggerKeys=True
      EnumerateSkipFirst=False

      [Hotkey/TriggerKeys]
      0=Caps_Lock
      1=Super+space

      [Hotkey/EnumerateForwardKeys]
      0=Caps_Lock
      1=Super+space

      [Hotkey/EnumerateBackwardKeys]
      0=Shift+Super+space

      [Behavior]
      ActiveByDefault=False
      ShareInputState=No
      PreeditEnabledByDefault=True
      ShowInputMethodInformation=True
      ShowInputMethodInformationWhenFocusIn=False
      CompactInputMethodInformation=True
      ShowFirstInputMethodInformation=True
      DefaultPageSize=5
      OverrideXkbOption=False
      PreloadInputMethod=True
    '';
  };

}
