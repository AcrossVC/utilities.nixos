# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1ff18c2b-ff62-4cd9-abb3-8129c6b3143c";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-34aeb013-9b44-4424-ac1c-66511e9463f9".device = "/dev/disk/by-uuid/34aeb013-9b44-4424-ac1c-66511e9463f9";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2263-779C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    # Add this section for automatic, consistent mounting
  fileSystems."/mnt/T7" = {
    device = "/dev/disk/by-uuid/6A0E092F0E08F63B";  # Your drive's UUID
    fsType = "ntfs3";
    options = [ 
      "rw"                    # Read-write access
      "uid=1000"             # Your user's UID
      "gid=1000"             # Your user's GID
      #"windows_names"         # Handle Windows-style filenames
      #"big_writes"           # Improve write performance
      #"compress"             # Enable compression for better performance


      #"nosuid"               # Security measure: disable SUID
      #"nodev"               # Security measure: disable device files
      #"dmask=022"            # Directory permissions mask
      #"fmask=133"            # File permissions mask
      #"umask=022"

      #"uid=${toString config.users.users.user.uid}"  # Your user owns the mount
      #"gid=${toString config.users.users.user.gid}"
      "windows_names"         # Handle Windows filenames properly
      "big_writes"           # Optimize for large file operations (good for games)
      "noatime"              # Reduce unnecessary writes
      "nofail"               # Don't halt boot if drive isn't connected
      "x-systemd.automount"  # Automatically mount when accessed
      #"x-systemd.idle-timeout=60"  # Keep mounted for 1 minute after last access

    ];
  };

  # Add udev rules to ensure consistent device naming
  services.udev.extraRules = ''
    # Samsung T7 Shield specific rule
    SUBSYSTEM=="block", ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="61fb", SYMLINK+="T7_drive"
  '';


  swapDevices =
    [ { device = "/dev/disk/by-uuid/a4b8de7a-6161-4aee-b1b4-c45fa54a8820"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
