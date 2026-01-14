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
    let
      defaultModules = hostname: system: [
        ./hosts/${hostname}
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.noeleon = import ./hosts/${hostname}/home.nix;
          home-manager.sharedModules = [
            nixvim.homeModules.nixvim
          ];

          home-manager.extraSpecialArgs = {
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
        }
      ];
    in
    {
      nixosConfigurations = {
        nixos =
          let
            system = "x86_64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in
          nixpkgs.lib.nixosSystem {
            modules = defaultModules "nixos" system ++ [
              {
                environment.systemPackages = [
                  pkgs-unstable.zed-editor
                ];
                home-manager.sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                ];
              }
            ];
            specialArgs = { inherit inputs; };
          };
        m1x =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            modules = defaultModules "m1x" system ++ [
              {
                home-manager.sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                ];
              }
            ];
            specialArgs = { inherit inputs; };
          };
        m2x =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            modules = defaultModules "m2x" system;
            specialArgs = { inherit inputs; };
          };
      };
    };
}
