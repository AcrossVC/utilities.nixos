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
      driSupport = true;  # Enable Direct Rendering Infrastructure
      driSupport32Bit = true;  # Needed for Steam
      extraPackages = with pkgs; [
        vaapiVdpau  # Better video acceleration support
        libvdpau-va-gl
      ];
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

      # Enable better wayland support
      #forceFullCompositionPipeline = true;
    };

    
    # PRIME configuration for hybrid graphics
    hardware.nvidia.prime = {
      sync.enable = true;
      nvidiaBusId = config.modules.nvidia.busId;
      intelBusId = config.modules.nvidia.intelBusId;
      
      # Offload by default - this can help with cursor issues
      #offload.enable = true;
      #offload.enableOffloadCmd = true;
    };

    # Required kernel modules
    boot.initrd.kernelModules = [ "nvidia" ];  # "nvidia_modeset" "nvidia_uvm" "nvidia_drm"
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

    # Environment variables for better Wayland/Steam compatibility
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";  # Better Electron app support
      #WLR_NO_HARDWARE_CURSORS = "1";  # Force software cursors globally
      #XCURSOR_SIZE = "16";
      #XCURSOR_THEME = "Posy_Cursor";
      
      # These can help with certain Steam games
      #GBM_BACKEND = "nvidia-drm";
      #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
      #LIBVA_DRIVER_NAME = "nvidia";  # Hardware acceleration
      # These help with rendering synchronization
      #__GL_SYNC_TO_VBLANK = "1";  # Enable vsync
      #__GL_SYNC_DISPLAY_DEVICE = "DP-0";  # Sync to primary display
      #LIBGL_DRI3_DISABLE = "1";  # Can help with cursor issues
    };

    # Add system-wide Vulkan support
    hardware.steam-hardware.enable = true;
  };
}