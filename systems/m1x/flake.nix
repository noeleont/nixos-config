{
  description = "m1x";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-pkg.url = "github:noeleont/nvim.nix";
    personal-config.url = "github:noeleont/nix/25.05";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nvim-pkg,
      personal-config,
      ...
    }: let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.m1x = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.overlays = [
              nvim-pkg.overlays.default
            ];
          }
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.noeleon = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit personal-config;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
