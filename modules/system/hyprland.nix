# /etc/nixos/home/hyprland.nix

{ config, pkgs, ... }: 
{
  # Hyprland config file
  home.file."~/.config/hypr/hyprland.conf".text = ''
    # Monitor configuration
    monitor=,preferred,auto,1

    # Execute at launch
    exec-once = waybar  # Status bar
    exec-once = dunst   # Notifications
    
    # Some default env vars
    env = XCURSOR_SIZE,24

    # Input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = false
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification
    }

    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
        layout = dwindle
    }

    decoration {
        rounding = 10
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = true
        # Animation curves
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
        pseudotile = true
        preserve_split = true
    }

    master {
        new_is_master = true
    }

    # Window rules
    windowrule = float, ^(pavucontrol)$
    windowrule = float, ^(nm-connection-editor)$

    # Key bindings
    $mainMod = SUPER

    # Basic bindings
    bind = $mainMod, Return, exec, wezterm
    bind = $mainMod, Q, killactive,
    bind = $mainMod SHIFT, Q, exit,
    bind = $mainMod, Space, exec, rofi -show drun
    bind = $mainMod, E, exec, nautilus
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Mouse bindings
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';

  # Waybar configuration
  home.file."~/.config/waybar/config".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 30,
      "modules-left": ["hyprland/workspaces", "hyprland/window"],
      "modules-center": ["clock"],
      "modules-right": ["network", "cpu", "memory", "battery", "tray"],
      
      "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d}"
      },
      "cpu": {
        "format": "CPU {usage}%"
      },
      "memory": {
        "format": "RAM {}%"
      },
      "battery": {
        "format": "BAT {capacity}%"
      },
      "network": {
        "format-wifi": "WiFi ({signalStrength}%)",
        "format-ethernet": "ETH",
        "format-disconnected": "Disconnected"
      },
      "tray": {
        "spacing": 10
      }
    }
  '';

  # Waybar style
  home.file."~/.config/waybar/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background: #1e1e2e;
      color: #cdd6f4;
    }

    #workspaces button {
      padding: 0 5px;
      background: transparent;
      color: #cdd6f4;
    }

    #workspaces button.active {
      background: #313244;
      border-bottom: 2px solid #cba6f7;
    }
  '';
}