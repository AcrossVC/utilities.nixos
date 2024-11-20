# /etc/nixos/home/user.nix
{ pkgs, ... }: {
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

  # Add VSCode configuration
  programs.vscode = {
    enable = true;
    # We'll keep using the system VSCode for now
    # This ensures we don't break your existing setup
    package = pkgs.vscode;
    
    # Enable VSCode's built-in features
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    # We'll add extensions and settings in the next iteration
    # after confirming this basic setup works
  };
}
