# /etc/nixos/home/user.nix
{ pkgs, inputs, ... }: {
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "24.05";
    
    packages = with pkgs; [
      # Terminal Emulators (in order of preference)
      kitty           # Primary
      wezterm        # Secondary
      alacritty      # Tertiary (fallback)
      
      # Core Wayland Utilities
      wl-clipboard    # Wayland clipboard manager
      grim           # Screenshot utility
      slurp          # Screen area selection
      swww           # Wallpaper utility
      
      # System Interaction
      brightnessctl   # Brightness control
      pamixer         # Audio control
      playerctl       # Media player control
      light           # Alternative brightness control
      
      # File Management
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      gnome.nautilus      # Secondary file manager
      gnome.file-roller   # Archive manager
      
      # Development & Productivity
      firefox
      thunderbird
      keepassxc
      vscode

      # Hyprland Essential Tools
      waybar          # Status bar
      dunst           # Notifications
      rofi-wayland    # Application launcher
      
      # Theme & Appearance
      papirus-icon-theme
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      
      # System Utilities
      gnome.gnome-keyring
      gnome.seahorse     # GUI for keyring
      libsecret         # Secret storage
    ];
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Terminal Configuration
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      enable_audio_bell = false;
      background_opacity = "0.95";
    };
  };

  # Hyprland Configuration
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;  # Better systemd integration
    xwayland.enable = true;

    settings = {
      # Monitor configuration
      monitor = [",preferred,auto,1"];
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = false;
        sensitivity = 0;
      };

      # General window behavior
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Window decoration
      decoration = {
        rounding = 10;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # Key bindings - Simplified but comprehensive
      "$mainMod" = "SUPER";
      "$altMod" = "ALT";
      "$shiftMod" = "SHIFT";

      bind = [
        # Essential Applications
        "$mainMod, Return, exec, kitty"  # Terminal
        "$mainMod SHIFT, Return, exec, wezterm"  # Secondary terminal
        "$mainMod, Space, exec, rofi -show drun"  # App launcher
        "$mainMod, Q, killactive,"  # Close window
        "$mainMod SHIFT, Q, exit,"  # Log out of Hyprland
        "$mainMod, E, exec, thunar"  # File manager
    
        # Window Focus - Home Row (Vim-style)
        "$mainMod, h, movefocus, l"  # Focus left
        "$mainMod, l, movefocus, r"  # Focus right
        "$mainMod, k, movefocus, u"  # Focus up
        "$mainMod, j, movefocus, d"  # Focus down
    
        # Window Movement - Home Row
        "$mainMod SHIFT, h, movewindow, l"  # Move window left
        "$mainMod SHIFT, l, movewindow, r"  # Move window right
        "$mainMod SHIFT, k, movewindow, u"  # Move window up
        "$mainMod SHIFT, j, movewindow, d"  # Move window down

        # Window States
        "$mainMod, F, fullscreen, 0"  # Full screen
        "$mainMod, V, togglefloating"  # Toggle float
    
        # Window Snapping (Using Numpad Layout on Main Keys)
        "$mainMod CTRL, h, splitratio, -0.3"  # Resize left
        "$mainMod CTRL, l, splitratio, +0.3"  # Resize right

        # Window Snapping - Directional
        "$mainMod ALT, left, movewindow, l"  # Snap to left half
        "$mainMod ALT, right, movewindow, r"  # Snap to right half
        "$mainMod ALT, up, movewindow, u"  # Snap to top half
        "$mainMod ALT, down, movewindow, d"  # Snap to bottom half

        # Corner Snapping
        "$mainMod CTRL, 7, movewindow, ul"  # Upper left corner
        "$mainMod CTRL, 9, movewindow, ur"  # Upper right corner
        "$mainMod CTRL, 1, movewindow, dl"  # Lower left corner
        "$mainMod CTRL, 3, movewindow, dr"  # Lower right corner
    
        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
    
        # Move Windows to Workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"

        # Explicit Function Key Bindings (in addition to Fn key handling)
        ", XF86AudioLowerVolume, exec, pamixer -d 5"   # Fn + F2
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"   # Fn + F3
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"  # Fn + F11
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"    # Fn + F12
    
        # Explicit backup bindings if Fn keys don't work
        "$mainMod, F2, exec, pamixer -d 5"
        "$mainMod, F3, exec, pamixer -i 5"
        "$mainMod, F11, exec, brightnessctl set 5%-"
        "$mainMod, F12, exec, brightnessctl set 5%+"
      ];

      # Media key bindings
      bindel = [
        # Volume keys
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
    
        # Brightness keys
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Additional media controls
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };

    # Startup applications and environment
    extraConfig = ''
      # Essential startup applications
      exec-once = waybar
      exec-once = dunst
      
      # Environment variables
      env = WLR_NO_HARDWARE_CURSORS,1
      env = XCURSOR_SIZE,24
      env = XCURSOR_THEME,Papirus
      env = GTK_THEME,Adwaita-dark
      
      # Window rules
      windowrule = float, ^(thunar)$
      windowrule = size 1200 800, ^(thunar)$
      windowrule = center, ^(thunar)$

      # GNOME Keyring integration
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

  # Default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop" "nautilus.desktop"];
      "text/plain" = ["code.desktop"];
      "text/html" = ["firefox.desktop"];
    };
  };
}