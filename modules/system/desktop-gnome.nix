# /etc/nixos/modules/system/desktop-gnome.nix
{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.modules.desktop;
in {
  config = mkIf (cfg.enable && cfg.active == "gnome") {
    # Enable X11 and GNOME
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      
      # X11 keyboard layout
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable sound with pipewire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Required Gnome packages from your original config
    services.xserver.excludePackages = [ pkgs.xterm ];
    
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
  };
}
