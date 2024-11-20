{
  description = "NixOS configuration";

  inputs = {
    # Use nixos-24.05 to match your current system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    
    # Hardware support for your Lenovo Legion
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # We'll add home-manager after confirming this works
    # home-manager.url = "github:nix-community/home-manager/release-24.05";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      # Your hostname from configuration.nix
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Your existing configuration
          ./configuration.nix
          
          # Hardware support for Lenovo Legion
          nixos-hardware.nixosModules.lenovo-legion-15
        ];
      };
    };
  };
}
