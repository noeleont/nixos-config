{
  description = "NixOS configs for my machines";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      plasma-manager,
      ...
    }:
    {
      nixosConfigurations = {
        nixos =
          let
            system = "x86_64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in
          nixpkgs.lib.nixosSystem {
            modules = [
              ./systems/nixos/configuration.nix
              ./systems/nixos/modules/steam.nix
              home-manager.nixosModules.home-manager
              {
                environment.systemPackages = [
                  pkgs-unstable.zed-editor
                ];

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.noeleon = import ./systems/nixos/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable;
                };
                home-manager.sharedModules = [
                  nixvim.homeModules.nixvim
                  plasma-manager.homeModules.plasma-manager
                ];
              }
            ];
            specialArgs = { inherit inputs; };
          };
        m1x =
          let
            system = "aarch64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in
          nixpkgs.lib.nixosSystem {
            modules = [
              ./systems/m1x/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.noeleon = import ./systems/m1x/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable;
                };
                home-manager.sharedModules = [
                  nixvim.homeModules.nixvim
                  plasma-manager.homeModules.plasma-manager
                ];
              }
            ];
            specialArgs = { inherit inputs; };
          };
        m2x =
          let
            system = "aarch64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in
          nixpkgs.lib.nixosSystem {
            modules = [
              ./systems/m2x/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.noeleon = import ./systems/m2x/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable;
                };
                home-manager.sharedModules = [
                  nixvim.homeModules.nixvim
                ];
              }
            ];
            specialArgs = { inherit inputs; };
          };
      };
    };
}
