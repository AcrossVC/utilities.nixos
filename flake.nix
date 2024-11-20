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
          { nixpkgs.overlays = [ overlay-unstable ]; }
          ./configuration.nix   

          # Hyprland module enable 
          ./modules/system/hyprland.nix
          {
            modules.hyprland.enable = true;
          }
     
          #nvidia module enable
          ./modules/system/nvidia.nix
          {
            # Enable and configure NVIDIA
            modules.nvidia = {
              enable = true;
              # Verify these bus IDs match your system
              busId = "PCI:1:0:0";
              intelBusId = "PCI:0:2:0";
            };
          }

          # Home-manager module enable and import
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.user = import ./home/user.nix;
            };
          }
        ];
      };
    };
}