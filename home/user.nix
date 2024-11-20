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
      
      # Hyprland-specific packages
      waybar
      dunst
      rofi-wayland
      papirus-icon-theme
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      
      # Additional utilities for Wayland
      wl-clipboard    # Clipboard functionality
      grim           # Screenshot utility
      slurp          # Screen area selection
      swww           # Wallpaper utility
      wev            # Debug key events (useful for fixing SUPER key)
    ];
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Hyprland configuration through home-manager
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
      
      bind = [
        "$mainMod, Return, exec, wezterm"
        "$altMod, Return, exec, wezterm"  # Backup binding
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, Space, exec, rofi -show drun"
        "$altMod, Space, exec, rofi -show drun"  # Backup binding
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating,"
        # Add more of your existing bindings here
      ];
    };

    # Your existing manual config as fallback
    extraConfig = ''
      # Startup applications
      exec-once = waybar
      exec-once = dunst
      
      # Environment variables
      env = XCURSOR_SIZE,24
      env = XCURSOR_THEME,Papirus
      env = GTK_THEME,Adwaita-dark
      
      # Additional window rules
      windowrule = float, ^(pavucontrol)$
      windowrule = float, ^(nm-connection-editor)$
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

  # Ensure proper DBus/systemd integration
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}