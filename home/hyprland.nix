# /etc/nixos/home/hyprland.nix
{ config, pkgs, ... }: {
  # Hyprland config file
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Moniter configuration
    monitor=,preferred,auto,1

    # Execute at launch
    exec-once = waybar  # Status bar
    exec-once = dunst  # Notifications

    # Basic environment variables
    env = XCURSOR_SIZE,24
    env = WLR_NO_HARDWARE_CURSORS,1

    # Some default env vars
    input {
      kb_layout = us
      follow_mouse = 1
      touchpad {
        natural_scroll = false
      }
      sensitivity = 0 # -1.0 - 1.0, 0 means no modificaiton 
    }

#     general {
#     }

#     decoration {
#     }

#     animations {
#     }

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

    # Key Bindings
    $mainMod = SUPER

    # Basic bindings
    bind = $mainMod, Return, exec, wezterm
    bind = $mainMod, q, killactive
    bind = $mainMod SHIFT, Q, exit
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

#   # Waybar configuration
#   xdg.configFile."waybar/config".text = ''
#   '';

#   # Waybar style
#   xdg.configFile."waybar/style.css".text = ''
#   '';
}
