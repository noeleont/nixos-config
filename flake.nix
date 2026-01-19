{
  description = "NixOS configs for my machines";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      nix-darwin,
      home-manager,
      nixvim,
      plasma-manager,
      ...
    }:
    let
      defaultModules = hostname: system: [
        ./hosts/${hostname}
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
      darwinConfigurations.m2ma =
        let
          system = "aarch64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          modules = defaultModules "m2ma" system ++ [
            home-manager.darwinModules.home-manager
            { }
          ];
          specialArgs = { inherit inputs; };
        };
      nixosConfigurations = {
        nixos =
          let
            system = "x86_64-linux";
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in
          nixpkgs.lib.nixosSystem {
            modules = defaultModules "nixos" system ++ [
              home-manager.nixosModules.home-manager
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
              home-manager.nixosModules.home-manager
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
            modules = defaultModules "m2x" system ++ [
              home-manager.nixosModules.home-manager
            ];
            specialArgs = { inherit inputs; };
          };
      };
    };
}
