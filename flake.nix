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

    # Theme-related inputs
    catppuccin-kvantum = {
      url = "github:catppuccin/kvantum";
      flake = false;
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
      # Define multiple system configurations
      nixosConfigurations = {
        # Main system with GNOME
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ overlay-unstable ]; }
            ./configuration.nix
            ./modules/system/nvidia.nix
            ./modules/system/desktop-environments.nix
            ./modules/system/desktop-gnome.nix
            ./modules/system/desktop-i3.nix
            {
              modules = {
                nvidia.enable = true;
                desktop = {
                  enable = true;
                  active = "gnome";
                  #   theme = {
                  #   name = "catppuccin";
                  #   flavor = "Mocha";
                  #   accent = "Blue";
                  # };
                };
              };
            }
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

        # Alternative i3 configuration
        i3 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ overlay-unstable ]; }
            ./configuration.nix
            ./modules/system/nvidia.nix
            ./modules/system/desktop-environments.nix
            ./modules/system/desktop-gnome.nix
            ./modules/system/desktop-i3.nix
            {
              modules = {
                nvidia.enable = true;
                desktop = {
                  enable = true;
                  active = "i3";
                  theme = {
                    name = "catppuccin";
                    flavor = "Mocha";
                    accent = "Mauve";
                  };
                };
              };
            }
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
    };
}