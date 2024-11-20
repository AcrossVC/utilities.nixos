# /etc/nixos/home/user.nix
{ pkgs, ... }: {

#   imports = [
#     ../modules/system/hyprland.nix
#   ];

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

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };
}
