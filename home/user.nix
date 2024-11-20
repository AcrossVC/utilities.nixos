# /etc/nixos/home/user.nix
{ pkgs, ... }: {
  imports = [ 
    ./vscode.nix
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
    ];
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

}
