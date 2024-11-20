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
    ];

  };
}