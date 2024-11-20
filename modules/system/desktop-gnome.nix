# /etc/nixos/modules/system/desktop-gnome.nix

# This module configures GNOME with theming and extensions
{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.modules.desktop;
  theme = cfg.theme;
in {
  config = mkIf (cfg.enable && cfg.active == "gnome") {
    # Enable GNOME Desktop Environment
    services.xserver.desktopManager.gnome.enable = true;

    # Combined package list
    environment.systemPackages = with pkgs; [
      # GNOME utilities
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome-extension-manager
      
      # GNOME Shell Extensions
      gnomeExtensions.user-themes
      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
    ];

    # Theme configuration through home-manager
    home-manager.users.user = {
      # GNOME settings via dconf
      dconf.settings = {
        # Theme settings
        "org/gnome/shell/extensions/user-theme" = {
          name = "Catppuccin-${theme.flavor}-Standard-${theme.accent}-Dark";
        };
        
        # Interface settings
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Catppuccin-${theme.flavor}-Standard-${theme.accent}-Dark";
          cursor-theme = "Catppuccin-${theme.flavor}-Cursors";
          icon-theme = "Papirus-Dark";
        };

        # Window manager settings
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          theme = "Catppuccin-${theme.flavor}-Standard-${theme.accent}-Dark";
        };
      };
    };
  };
}