{ pkgs, config, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod1";  # Alt key (same as aerospace)
      terminal = "${pkgs.wezterm}/bin/wezterm";
      menu = "${pkgs.wofi}/bin/wofi --show drun";

      # Font for window titles
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 10.0;
      };

      # No gaps (same as aerospace config)
      gaps = {
        inner = 0;
        outer = 0;
      };

      # No window borders
      window = {
        border = 0;
        titlebar = false;
      };

      # Focus follows mouse
      focus.followMouse = true;

      # Keybindings (mirroring aerospace)
      keybindings = let
        mod = "Mod1";  # Alt
        mod2 = "Mod1+Shift";  # Alt+Shift
      in {
        # Layout switching (like aerospace alt-slash and alt-comma)
        "${mod}+slash" = "layout toggle split";
        "${mod}+comma" = "layout stacking tabbed split";
        "${mod}+f" = "floating toggle";

        # Focus movement (same as aerospace)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move windows (same as aerospace)
        "${mod2}+h" = "move left";
        "${mod2}+j" = "move down";
        "${mod2}+k" = "move up";
        "${mod2}+l" = "move right";

        # Resize (similar to aerospace)
        "${mod}+minus" = "resize shrink width 50px";
        "${mod}+equal" = "resize grow width 50px";

        # Workspaces 1-9 (same as aerospace)
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        # Named workspaces (same as aerospace)
        "${mod}+a" = "workspace A";
        "${mod}+b" = "workspace B";
        "${mod}+c" = "workspace C";
        "${mod}+d" = "workspace D";
        "${mod}+e" = "workspace E";
        "${mod}+g" = "workspace G";
        "${mod}+i" = "workspace I";
        "${mod}+m" = "workspace M";
        "${mod}+n" = "workspace N";
        "${mod}+o" = "workspace O";
        "${mod}+p" = "workspace P";
        "${mod}+q" = "workspace Q";
        "${mod}+r" = "workspace R";
        "${mod}+s" = "workspace S";
        "${mod}+t" = "workspace T";
        "${mod}+u" = "workspace U";
        "${mod}+v" = "workspace V";
        "${mod}+w" = "workspace W";
        "${mod}+x" = "workspace X";
        "${mod}+y" = "workspace Y";
        "${mod}+z" = "workspace Z";

        # Move to workspace (same as aerospace)
        "${mod2}+1" = "move container to workspace number 1; workspace number 1";
        "${mod2}+2" = "move container to workspace number 2; workspace number 2";
        "${mod2}+3" = "move container to workspace number 3; workspace number 3";
        "${mod2}+4" = "move container to workspace number 4; workspace number 4";
        "${mod2}+5" = "move container to workspace number 5; workspace number 5";
        "${mod2}+6" = "move container to workspace number 6; workspace number 6";
        "${mod2}+7" = "move container to workspace number 7; workspace number 7";
        "${mod2}+8" = "move container to workspace number 8; workspace number 8";
        "${mod2}+9" = "move container to workspace number 9; workspace number 9";

        "${mod2}+a" = "move container to workspace A; workspace A";
        "${mod2}+b" = "move container to workspace B; workspace B";
        "${mod2}+c" = "move container to workspace C; workspace C";
        "${mod2}+d" = "move container to workspace D; workspace D";
        "${mod2}+e" = "move container to workspace E; workspace E";
        "${mod2}+g" = "move container to workspace G; workspace G";
        "${mod2}+i" = "move container to workspace I; workspace I";
        "${mod2}+m" = "move container to workspace M; workspace M";
        "${mod2}+n" = "move container to workspace N; workspace N";
        "${mod2}+o" = "move container to workspace O; workspace O";
        "${mod2}+p" = "move container to workspace P; workspace P";
        "${mod2}+q" = "move container to workspace Q; workspace Q";
        "${mod2}+r" = "move container to workspace R; workspace R";
        "${mod2}+s" = "move container to workspace S; workspace S";
        "${mod2}+t" = "move container to workspace T; workspace T";
        "${mod2}+u" = "move container to workspace U; workspace U";
        "${mod2}+v" = "move container to workspace V; workspace V";
        "${mod2}+w" = "move container to workspace W; workspace W";
        "${mod2}+x" = "move container to workspace X; workspace X";
        "${mod2}+y" = "move container to workspace Y; workspace Y";
        "${mod2}+z" = "move container to workspace Z; workspace Z";

        # Move workspace to another monitor
        "${mod2}+Tab" = "move workspace to output right";

        # Reload config (like aerospace service mode)
        "${mod2}+semicolon" = "reload";

        # Close window
        "${mod2}+q" = "kill";

        # Application launcher
        "${mod}+space" = "exec ${pkgs.wofi}/bin/wofi --show drun";

        # Terminal
        "${mod}+Return" = "exec ${pkgs.wezterm}/bin/wezterm";

        # Lock screen
        "${mod2}+Delete" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 000000";
      };

      # Status bar
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];

      # Startup commands
      startup = [
        { command = "${pkgs.mako}/bin/mako"; }  # Notification daemon
      ];

      # Input configuration
      input = {
        "*" = {
          xkb_layout = "us";
          # Enable tap-to-click for touchpads
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };

      # Output configuration (can be customized per machine)
      output = {
        "*" = {
          bg = "#1a1b26 solid_color";  # Tokyo Night background
        };
      };
    };

    # Extra config for things not covered by the module
    extraConfig = ''
      # Hide mouse cursor after inactivity
      seat * hide_cursor 5000

      # Enable XWayland for X11 app compatibility
      xwayland enable
    '';
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "clock" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "CPU {usage}%";
        };

        memory = {
          format = "MEM {}%";
        };

        network = {
          format-wifi = "WIFI {signalStrength}%";
          format-ethernet = "ETH";
          format-disconnected = "DISCONNECTED";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTED";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.9);
        color: #c0caf5;
      }

      #workspaces button {
        padding: 0 5px;
        color: #565f89;
      }

      #workspaces button.focused {
        color: #7aa2f7;
        background-color: rgba(122, 162, 247, 0.2);
      }

      #clock, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
      }
    '';
  };
}
