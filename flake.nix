# /etc/nixos/flake.nix
{
  description = "NixOS configuration";

  inputs = {
    # Stable system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # Add unstable for specific packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Keep hardware support if needed later
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      # Configure unstable overlay
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${system};
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          # Add overlay to system
          { nixpkgs.overlays = [ overlay-unstable ]; }
          
          # Your existing configuration
          ./configuration.nix
          
          # Home-manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
               users.user = { ... }: {
                imports = [ ./home/user.nix ];
              };
            };
          }
        ];
      };
    };
}
