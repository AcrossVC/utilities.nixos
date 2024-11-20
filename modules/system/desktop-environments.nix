# /etc/nixos/modules/system/desktop-environments.nix

# This module defines the base desktop environment configuration and options
# It serves as the foundation for specific desktop environment configurations
{ config, lib, pkgs, ... }:

with lib;

{
  # Define the core options for desktop environments
  options.modules.desktop = {
    # Master switch for desktop configuration
    enable = mkEnableOption "desktop environment configuration";
    
    # Selection of active desktop environment
    active = mkOption {
      type = types.enum [ "gnome" "i3" ];
      default = "gnome";
      description = "Which desktop environment to activate";
    };

    # Theme configuration
    theme = {
      # Theme selection
      name = mkOption {
        type = types.enum [ "catppuccin" ];
        default = "catppuccin";
        description = "Theme name to apply across desktop environments";
      };

      # Theme variant/flavor
      flavor = mkOption {
        type = types.enum [ "mocha" "macchiato" "frappe" "latte" ];
        default = "mocha";
        description = "Specific variant of the selected theme";
      };

      # Accent color - useful for some themes
      accent = mkOption {
        type = types.enum [ "Blue" "Red" "Green" "Yellow" "Pink" "Mauve" ];
        default = "Blue";
        description = "Accent color for theme customization";
      };
    };
  };

  # Base configuration shared across all desktop environments
  config = mkIf config.modules.desktop.enable {
    # Enable X server - required for both GNOME and i3
    services.xserver = {
      enable = true;
      
      # Default keyboard configuration - can be overridden in specific DE configs
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # GDM as the default display manager
    services.xserver.displayManager.gdm.enable = true;

    # Common theme-related packages
    environment.systemPackages = with pkgs; [
      # Theme packages
      catppuccin-gtk
      (catppuccin-kvantum.override {
        accent = config.modules.desktop.theme.accent;
        variant = config.modules.desktop.theme.flavor;
      })
    ];
  };
}