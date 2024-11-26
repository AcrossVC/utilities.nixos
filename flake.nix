{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      # Configure overlay for unstable packages
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${system};
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit inputs;
          # Make unstable available in configs
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system}; 
        };
        modules = [
          # Overlays
          { nixpkgs.overlays = [ overlay-unstable ]; }

          # Base system configuration
          ./configuration.nix   

          # Working Nvidia Module
          ./modules/system/nvidia.nix
          {
            modules.nvidia = {
              enable = true;
              busId = "PCI:1:0:0";
              intelBusId = "PCI:0:2:0";
            };
          }

          # Proper Hyprland integration
          hyprland.nixosModules.default
          {
            programs.hyprland = {
              enable = true;
              xwayland.enable = true;
              # Ensure proper package version
              package = hyprland.packages.${system}.hyprland;
            };
          }

          
          

          # Home-manager module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = ".backup";
              extraSpecialArgs = { inherit inputs; };
              users.user = import ./home/user.nix;
            };
          }
        ];
      };
    };
}
