# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-4be4e646-3f6f-4179-9139-2efad8c07b97".device = "/dev/disk/by-uuid/4be4e646-3f6f-4179-9139-2efad8c07b97";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

 # These are your locale settings
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
 
  # "alternitive display manager" trying to enable wayland.
  #services.xserver.displayManager.sddm.enable = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  }; 

  # Cachix required by hyprland wiki
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Create a new group for Nix configuration
  users.groups.nixconfig = {};

   # Set proper permissions for /etc/nixos and all its contents
  system.activationScripts.nixos-config-perms = {
    text = ''
      echo "Setting up permissions for /etc/nixos"
      chown -R root:nixconfig /etc/nixos
      find /etc/nixos -type d -exec chmod 775 {} \;
      find /etc/nixos -type f -exec chmod 664 {} \;
    '';
    deps = [];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" "nixconfig"];
    shell = pkgs.bash;
    packages = with pkgs; [
      thunderbird
      vscode
      keepassxc
      firefox
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #hyprland pkgs
  kitty
  wezterm  # terminal
  rofi-wayland  # application launcher
  waybar  # status bar
  dunst  # notifications
  jetbrains-mono  #font for waybar
  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # end of hyprland pkgs
  pciutils
  git
  python3
  neofetch
  gedit
  keepassxc
  thunderbird
  gparted
  vscode-with-extensions
  tor
  neovim 
  wget
  libreoffice
  #   atlauncher
  (pkgs.atlauncher.override {
    jre = temurin-jre-bin-8;
  })
  #   prismlauncher
  steam
  gamescope
  mangohud
  gamemode
  wine
  winetricks
  tor-browser
  desktop-file-utils
  xdg-utils
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-gnome 
  xdg-desktop-portal-hyprland  # added this nonsense for hyprland before enabling it. may do nothing.

 # These provide the OpenGL libraries that Electron apps need
    # They're already part of your system due to your hardware.opengl settings,
    # but we're making them explicitly available to GitHub Desktop
    libGL     # The main OpenGL library
    libglvnd  # The OpenGL vendor-neutral dispatch library
  #   github-desktop
    (symlinkJoin {
      name = "github-desktop-wrapped";
      paths = [ github-desktop ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/github-desktop \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
            libGL
            libglvnd
          ]} \
         --set EDITOR "code" \
         --set VISUAL "code"
  #          --set EDITOR ${pkgs.vscode}/bin/code \  # Absolute path
  #          --set VISUAL ${pkgs.vscode}/bin/code
      '';
    })
  ];

  # Add this section for user-specific environment variables
  environment.interactiveShellInit = ''
    export EDITOR=${pkgs.vscode}/bin/code
    export VISUAL=${pkgs.vscode}/bin/code
  '';

  # Nix Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Add XDG MIME type and protocol handler
  xdg.mime.enable = true;
  xdg.icons.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

