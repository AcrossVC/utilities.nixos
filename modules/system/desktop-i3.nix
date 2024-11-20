# /etc/nixos/modules/system/desktop-i3.nix

# This module configures i3 window manager with theming and essential tools
{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.modules.desktop;
  theme = cfg.theme;

  # Catppuccin color definitions based on selected flavor
  colors = {
    Mocha = {
      rosewater = "#f5e0dc";
      flamingo  = "#f2cdcd";
      pink      = "#f5c2e7";
      Mauve     = "#cba6f7";
      red       = "#f38ba8";
      maroon    = "#eba0ac";
      peach     = "#fab387";
      yellow    = "#f9e2af";
      green     = "#a6e3a1";
      teal      = "#94e2d5";
      sky       = "#89dceb";
      sapphire  = "#74c7ec";
      blue      = "#89b4fa";
      lavender  = "#b4befe";
      text      = "#cdd6f4";
      subtext1  = "#bac2de";
      subtext0  = "#a6adc8";
      overlay2  = "#9399b2";
      overlay1  = "#7f849c";
      overlay0  = "#6c7086";
      surface2  = "#585b70";
      surface1  = "#45475a";
      surface0  = "#313244";
      base      = "#1e1e2e";
      mantle    = "#181825";
      crust     = "#11111b";
    };
    # Add other flavor color definitions as needed
  };
in {
  config = mkIf (cfg.enable && cfg.active == "i3") {
    # Enable i3 window manager
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      
      # Essential i3 packages
      extraPackages = with pkgs; [
        dmenu        # Application launcher
        i3status     # Status bar
        i3lock       # Screen locker
        i3blocks     # Status bar blocks
      ];
    };

    # Additional packages for a complete i3 desktop experience
    environment.systemPackages = with pkgs; [
      # Terminal emulator
      alacritty
      
      # System utilities
      rofi          # Modern application launcher
      dunst         # Notification daemon
      nitrogen      # Wallpaper manager
      picom         # Compositor for transparency
      arandr        # Display configuration
      feh           # Image viewer and wallpaper setter
      
      # System tray applications
      networkmanagerapplet
      pasystray     # PulseAudio system tray
      
      # Additional utilities
      xclip         # Clipboard manager
      maim          # Screenshot utility
      polybar       # Status bar alternative
    ];

    # Home-manager configuration for i3
    home-manager.users.user = {
      # i3 configuration
      xdg.configFile."i3/config".text = ''
        # i3 config file (v4)
        
        # Use Win/Super key as mod
        set $mod Mod4

        # Catppuccin ${theme.flavor} colors
        set_from_resource $rosewater ${colors.${theme.flavor}.rosewater}
        set_from_resource $flamingo  ${colors.${theme.flavor}.flamingo}
        # ... (continue with other colors)

        # Basic bar configuration
        bar {
          status_command i3status
          position top
          colors {
            background $base
            statusline $text
            separator  $surface0

            # class            border     background  text
            focused_workspace  $Blue      $Blue       $base
            active_workspace   $surface1  $surface1   $text
            inactive_workspace $base      $base       $text
            urgent_workspace   $red       $red        $base
          }
        }

        # Window colors
        client.focused          $Blue     $Blue      $base      $Blue
        client.focused_inactive $surface1 $surface1  $text      $surface1
        client.unfocused       $base     $base      $text      $base
        client.urgent          $red      $red       $base      $red

        # Basic key bindings
        bindsym $mod+Return exec alacritty
        bindsym $mod+d exec rofi -show drun
        bindsym $mod+Shift+q kill
        bindsym $mod+Shift+c reload
        bindsym $mod+Shift+r restart

        # ... additional i3 config ...
      '';

      # i3status configuration
      xdg.configFile."i3status/config".text = ''
        general {
          colors = true
          color_good = "${colors.${theme.flavor}.green}"
          color_degraded = "${colors.${theme.flavor}.yellow}"
          color_bad = "${colors.${theme.flavor}.red}"
          interval = 5
        }

        order += "wireless _first_"
        order += "battery all"
        order += "disk /"
        order += "memory"
        order += "tztime local"

        # ... status bar module configurations ...
      '';

      # Alacritty terminal configuration
      xdg.configFile."alacritty/alacritty.yml".text = ''
        window:
          padding:
            x: 10
            y: 10

        font:
          normal:
            family: "JetBrainsMono Nerd Font"
            style: Regular
          size: 11.0

        colors:
          primary:
            background: "${colors.${theme.flavor}.base}"
            foreground: "${colors.${theme.flavor}.text}"
          # ... additional color configurations ...
      '';
    };
  };
}