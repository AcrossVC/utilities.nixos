# /etc/nixos/modules/system/hyprland.nix

{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.hyprland = {
    enable = mkEnableOption "Hyprland configuration";
  };

  config = mkIf config.modules.hyprland.enable {
    # Don't disable GNOME - keep as fallback
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Add GDM session entry
    services.xserver.displayManager.gdm = {
      enable = true;  # Ensure GDM is enabled
      wayland = true; # Ensure Wayland is enabled
    };

    # Required environment variables for NVIDIA + Wayland
    environment.sessionVariables = {
      # NVIDIA specific
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";  # For Electron apps
      
      # XDG Specific
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    # Essential packages for basic rice
    environment.systemPackages = with pkgs; [
      waybar           # Status bar
      dunst           # Notification daemon
      rofi-wayland    # Application launcher
      swww            # Wallpaper
      grim            # Screenshot utility
      slurp           # Screen area selection
      libcanberra-gtk3  # For system sounds
      gnome.adwaita-icon-theme  # Default icons
      hicolor-icon-theme        # Fallback icons
    ];

    # Enable required services
    security.pam.services.swaylock = {};  # For screen locking
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };
}