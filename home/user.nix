# /etc/nixos/home/user.nix
{ pkgs, ... }: {
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "24.05";
    
    packages = with pkgs; [
      # Existing packages
      thunderbird
      keepassxc
      firefox
      
      # Terminal emulators (multiple options for reliability)
      kitty
      wezterm
      alacritty  # Added as another backup option
      
      # File managers and dependencies
      xfce.thunar  # Lightweight but feature-rich
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      gnome.nautilus  # GNOME's file manager
      gnome.file-roller  # Archive manager

      # Media control packages
      brightnessctl
      pamixer
      playerctl
      light

      # Hyprland-specific packages
      waybar
      dunst
      rofi-wayland
      papirus-icon-theme
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

       # File manager dependencies
      gvfs  # Virtual filesystem support
      xdg-user-dirs  # Creates default user directories
      
      # Additional utilities for Wayland
      wl-clipboard    # Clipboard functionality
      grim           # Screenshot utility
      slurp          # Screen area selection
      swww           # Wallpaper utility
      wev            # Debug key events (useful for fixing SUPER key)

       # Add these to your existing packages
      gnome.gnome-keyring
      gnome.seahorse
      libsecret
    ];
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Configure kitty terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      enable_audio_bell = false;
      background_opacity = "0.95";
    };
  };

# Hyprland configuration through home-managerbin
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    
    settings = {
      # Monitor configuration
      monitor = [
        ",preferred,auto,1"
      ];
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };

      # General configuration
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Add your existing decoration and animation settings here
      decoration = {
        rounding = 10;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # Key bindings - Including both SUPER and Alt as modifiers for flexibility
      "$mainMod" = "SUPER";
      "$altMod" = "ALT";
      

      bindel = [
        # Volume
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        
        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
      
      bindl = [
        # Media control
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];



      bind = [
        # Terminal bindings with fallbacks
        "$mainMod, Return, exec, kitty"  # Primary terminal
        "$mainMod SHIFT, Return, exec, wezterm"  # Secondary terminal
        "$altMod, Return, exec, alacritty"  # Tertiary terminal
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, Space, exec, rofi -show drun"
        "$altMod, Space, exec, rofi -show drun"  # Backup binding
        # File manager bindings with fallbacks
        "$mainMod, E, exec, thunar"  # Primary file manager
        "$mainMod SHIFT, E, exec, nautilus"  # Secondary file manager
        "$mainMod, V, togglefloating,"

        # Window focus movement with arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Window movement with arrow keys
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        
        # Resize submap activation
        "$mainMod, R, submap, resize"
        
        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move windows to workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Alternative volume controls
        "$mainMod, equal, exec, pamixer -i 5"
        "$mainMod, minus, exec, pamixer -d 5"
        "$mainMod, m, exec, pamixer -t"
        
        # Alternative brightness controls
        "$mainMod SHIFT, equal, exec, brightnessctl set 5%+"
        "$mainMod SHIFT, minus, exec, brightnessctl set 5%-"
      ];
      
      # Mouse bindings
      bindm = [
        # Move windows with mainMod + left mouse button
        "$mainMod, mouse:272, movewindow"
        # Resize windows with mainMod + right mouse button
        "$mainMod, mouse:273, resizewindow"
        # Alternative resize with Alt key
        "$altMod, mouse:273, resizewindow"
      ];
      
      # Resize submap configuration # Cause invalid request error
#     submap = {
#        resize = {
          # Reset submap
#          bind = [
#            "escape, submap, reset"
#            "Return, submap, reset"
#          ];
#          # Resize bindings
#          binde = [
#            "right, resizeactive, 10 0"
#            "left, resizeactive, -10 0"
#            "up, resizeactive, 0 -10"
#            "down, resizeactive, 0 10"
#          ];
#       };
#    };
    };

    # Your existing manual config as fallback
    extraConfig = ''
      # Startup applications
      exec-once = waybar
      exec-once = dunst
      exec-once = kitty
      exec-once = code
      exec-once = firefox
      
      # Environment variables
      env = WLR_NO_HARDWARE_CURSORS,1
      env = XCURSOR_SIZE,24
      env = XCURSOR_THEME,Papirus
      env = GTK_THEME,Adwaita-dark
      
      # File manager specific rules
      windowrule = float, ^(thunar)$
      windowrule = size 1200 800, ^(thunar)$
      windowrule = center, ^(thunar)$
      
      # Terminal specific rules
      windowrule = float, ^(kitty)$
      windowrule = size 1200 800, ^(kitty)$
      windowrule = center, ^(kitty)$

      # Start GNOME Keyring
      exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = ${pkgs.gnome.gnome-keyring}/libexec/gnome-keyring-daemon --daemonize --start --components=secrets
    '';
  };

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Configure default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop" "nautilus.desktop"];
      "text/plain" = ["kitty-open.desktop"];
    };
  };

  # Ensure proper DBus/systemd integration
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}