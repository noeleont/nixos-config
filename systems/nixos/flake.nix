{
  description = ".drive";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    }
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./modules/steam.nix
          {
            environment.systemPackages = [
              pkgs-unstable.zed-editor
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.noeleon = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit pkgs-unstable;
            };
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
