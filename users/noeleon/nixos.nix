{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.noeleon = {
    isNormalUser = true;
    home = "/home/noeleon";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$t4doGXkE.71gQml240qe70$YPBeW5X8OPwkWaNOjnqopgNgjZTLaQ3ZHbYVqSOAGG3";
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix)
  ];
}
