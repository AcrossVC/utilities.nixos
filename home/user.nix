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

      # Network
      networkmanagerapplet  # nm-applet for WiFi
    
      # Power/Session Management
      swaylock-effects     # Screen locking
      wlogout             # Logout menu
      
      # System Tray Tools
      blueman            # Bluetooth
      pavucontrol        # Audio control GUI

      # Screenshot and Recording
      grim              # Screenshot tool
      slurp             # Screen area selection
      wf-recorder       # Screen recording
      
      # Clipboard and Notifications
      cliphist          # Clipboard manager
      wl-clipboard      # Wayland clipboard utilities
      libnotify        # Notification sending
      
      # File Management Enhancement
      # xdg-utils        # For xdg-open, etc.
      # xdg-user-dirs    # Creates default user directories
      
      # Theming
      qt5ct            # Qt5 theme configuration
      qt6ct            # Qt6 theme configuration
      nwg-look         # GTK theme configuration
      
      # Wallpaper and Appearance
      swww             # Wallpaper daemon
      hyprpaper        # Alternative wallpaper utility
      
      # Additional Utilities
      polkit-kde-agent # Authentication popups
      
      # Optional but Useful
      gnome.gnome-disk-utility  # Disk management
      gnome.file-roller        # Archive manager
      imv                      # Image viewer
      mpv                      # Video player
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
        "$mainMod, b, togglefloating"  # Toggle float
    
        # Window Snapping (Using Numpad Layout on Main Keys)
        "$mainMod SHIFT, d, splitratio, -0.3"  # Resize left
        "$mainMod SHIFT, f, splitratio, +0.3"  # Resize right

        # Window Snapping - Directional
        "$mainMod, u, movewindow, l"  # Snap to left half
        "$mainMod, i, movewindow, r"  # Snap to right half
        "$mainMod, o, movewindow, u"  # Snap to top half
        "$mainMod, p, movewindow, d"  # Snap to bottom half

        # Corner Snapping
        "$mainMod, z, movewindow, ul"  # Upper left corner
        "$mainMod, x, movewindow, ur"  # Upper right corner
        "$mainMod, c, movewindow, dl"  # Lower left corner
        "$mainMod, v, movewindow, dr"  # Lower right corner
    
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

        # System Controls
        "$mainMod, P, exec, swaylock"  # Lock screen
        "$mainMod SHIFT, P, exec, wlogout"  # Power menu
        
        # Quick Settings
        #"$mainMod, N, exec, nm-connection-editor"  # Network settings
        #"$mainMod, B, exec, blueman-manager"  # Bluetooth
        #"$mainMod, P, exec, pavucontrol"  # Audio settings

        # Screenshot bindings
        "$mainMod, Print, exec, grim -g \"$(slurp)\" - | wl-copy"  # Area screenshot to clipboard
        "$mainMod SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"  # Area screenshot to file
        ", Print, exec, grim - | wl-copy"  # Full screenshot to clipboard
        
        # Clipboard history
        "$mainMod, M, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        
        # Color picker
        "$mainMod, y, exec, hyprpicker -a"
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
      exec-once = dunst
      exec-once = nm-applet --indicator
      exec-once = blueman-applet
      
      # Environment variables
      env = WLR_NO_HARDWARE_CURSORS,1
      env = XCURSOR_SIZE,16
      env = XCURSOR_THEME,Posy_Cursor
      env = GTK_THEME,Adwaita-dark
      
      # Window rules
      windowrule = float, ^(thunar)$
      windowrule = size 1200 800, ^(thunar)$
      windowrule = center, ^(thunar)$

      # GNOME Keyring integration
      exec-once = ${pkgs.gnome.gnome-keyring}/libexec/gnome-keyring-daemon --daemonize --start --components=secrets

      # Wallpaper
      exec-once = swww-daemon
      exec-once = swww img /home/user/heart/utilities/wallpapers/wallpaper.jpg  # Add your wallpaper path
      
      # Authentication agent
      exec-once = ${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      
      # Clipboard manager
      exec-once = wl-paste --type text --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store
      
      # Create default directories
      # exec-once = xdg-user-dirs-update
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
      "image/*" = ["imv.desktop"];
      "video/*" = ["mpv.desktop"];
      "application/pdf" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
    };
  };

  # Waybar Configuration
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.9);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 5px;
        color: #ffffff;
      }

      #workspaces button.active {
        background: #5294e2;
      }

      #clock, #battery, #pulseaudio, #network, #bluetooth {
        padding: 0 10px;
      }
    '';
    
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      margin-right = 10;  # Add margins to prevent power button overlap
      margin-left = 10;
      
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      
      modules-center = [
        "clock"
      ];
      
      modules-right = [
        "network"
        "bluetooth"
        "pulseaudio"
        "battery"
        "custom/power"
      ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };

      "clock" = {
        format = "{:%I:%M %p}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      "battery" = {
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
        format-charging = "{capacity}% ";
        interval = 30;
      };

      "network" = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈀 Connected";
        format-disconnected = "󰖪 Disconnected";
        tooltip-format = "{ipaddr}";
        on-click = "nm-connection-editor";
      };

      "bluetooth" = {
        format = " {status}";
        format-connected = " {device_alias}";
        format-off = "󰂲";
        on-click = "blueman-manager";
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-muted = "󰆸";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };

      "custom/power" = {
        format = "⏻";
        on-click = "wlogout -p layer-shell";  # Force proper layer-shell protocol
        tooltip = false;
      };
    }];
  };

  # Add power menu configuration (wlogout)
  programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "lock";
        "action" = "swaylock";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "hibernate";
        "action" = "systemctl hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }
      {
        "label" = "suspend";
        "action" = "systemctl suspend";
        "text" = "Suspend";
        "keybind" = "s";
      }
      {
        "label" = "logout";
        "action" = "loginctl terminate-user $USER";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "shutdown";
        "action" = "systemctl poweroff";
        "text" = "Shutdown";
        "keybind" = "p";
      }
      {
        "label" = "reboot";
        "action" = "systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
    ];
    style = ''
      * {
        background-image: none;
        font-family: "JetBrainsMono Nerd Font";
      }
      
      window {
        background-color: rgba(12, 12, 12, 0.9);
      }
      
      button {
        color: #FFFFFF;
        background-color: #1E1E1E;
        border-style: solid;
        border-width: 2px;
        border-radius: 8px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 5px;
        box-shadow: none;
        text-shadow: none;
        animation: none;
      }
      
      button:focus, button:active, button:hover {
        background-color: #3700B3;
        outline-style: none;
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };

  # Screen locker configuration
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      effect-blur = "7x5";
      fade-in = 0.2;
      font = "JetBrainsMono Nerd Font";
      show-failed-attempts = true;
      indicator = true;
      clock = true;
    };
  };

  # Configure notifications
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 100;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_width = 1;
        font = "JetBrainsMono Nerd Font 11";
      };
      urgency_low = {
        background = "#1E1E1E";
        foreground = "#FFFFFF";
      };
      urgency_normal = {
        background = "#1E1E1E";
        foreground = "#FFFFFF";
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#FFFFFF";
        frame_color = "#FF0000";
      };
    };
  };

  # Clipboard manager configuration
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history service";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "always";
    };
    Install.WantedBy = ["graphical-session.target"];
  };


# https://git.disroot.org/lwad/nixos/commit/93dfaee0787d09c9f99ee8e61fe916424a2586b1
  # https://www.reddit.com/r/NixOS/comments/1c24bnr/help_with_cursors/
  # Posey's cursor? 
  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor";
    package = pkgs.stdenvNoCC.mkDerivation {
      name = "posy-improved-cursor";

      src = pkgs.fetchFromGitHub {
        owner = "simtrami";
        repo = "posy-improved-cursor-linux";
        rev = "bd2bac08bf01e25846a6643dd30e2acffa9517d4";
        hash = "sha256-ndxz0KEU18ZKbPK2vTtEWUkOB/KqA362ipJMjVEgzYQ=";
      };

      dontBuild = true;

      installPhase = ''
        mkdir -p $out/share/icons
        mv Posy_Cursor "$out/share/icons/Posy's Cursor"
      '';
    };
    size = 16;
    #x11.enable = true;
    wayland.enable = true;
  };



}