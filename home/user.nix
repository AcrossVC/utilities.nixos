# /etc/nixos/home/user.nix
{ pkgs, ... }: {

  imports = [
    ../modules/system/hyprland.nix
  ];

  home = {
    username = "user";
    homeDirectory = "/home/user";
    
    # Don't change this value
    stateVersion = "24.05";
    
    # Start with existing packages to ensure nothing breaks
    packages = with pkgs; [
      thunderbird
      keepassxc
      firefox
      papirus-icon-theme
      font-awesome
    ];
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Initially, we'll keep vscode in system config
  # We'll move it to unstable after confirming this works
}
