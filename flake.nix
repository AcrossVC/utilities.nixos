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

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, hyprland, ... }@inputs:
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

          # Enable Hyprland properly with NVIDIA support
          hyprland.nixosModules.default
          {
          programs.hyprland = {
            enable = true;
            xwayland.enable = true;
            # nvidiaPatches = true;  # Nvidia patches are no longer needed
          };
          }

          # Your existing NVIDIA config
          ./modules/system/nvidia.nix
          {
          modules.nvidia = {
            enable = true;
            busId = "PCI:1:0:0";
            intelBusId = "PCI:0:2:0";
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
