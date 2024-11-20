# /etc/nixos/modules/system/nvidia.nix

# This module handles NVIDIA GPU configuration for Lenovo Legion y520-15ikbn
# with NVIDIA GeForce GTX 1050ti Mobile
{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.nvidia = {
    enable = mkEnableOption "NVIDIA configuration";
    
    busId = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
      description = "PCI bus ID of the NVIDIA GPU";
    };

    intelBusId = mkOption {
      type = types.str;
      default = "PCI:0:2:0";
      description = "PCI bus ID of the Intel GPU";
    };
  };

  config = mkIf config.modules.nvidia.enable {
    # Basic OpenGL support
    hardware.opengl = {
      enable = true;
    };

    # X11 video driver
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      
      # Disable experimental power management features
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      
      # Keep using proprietary driver for GTX 1050ti
      open = false;
      
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # PRIME configuration for hybrid graphics
    hardware.nvidia.prime = {
      sync.enable = true;
      nvidiaBusId = config.modules.nvidia.busId;
      intelBusId = config.modules.nvidia.intelBusId;
    };

    # Required kernel modules
    boot.initrd.kernelModules = [ "nvidia" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

    # Help with Electron apps under Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}