{
  description = ".drive";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-pkg.url = "github:noeleont/nvim.nix";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nvim-pkg,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./modules/steam.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              nvim-pkg.overlays.default
            ];

            nixpkgs.hostPlatform = system;

            environment.systemPackages = [
              pkgs-unstable.zed-editor
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.noeleon = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit pkgs-unstable;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
