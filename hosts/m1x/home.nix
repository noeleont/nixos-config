{ pkgs, ... }:

{
  imports = [
    ../../modules/home
    ../../modules/home/kde.nix
  ];

  home.username = "noeleon";
  home.homeDirectory = "/home/noeleon";

  # System-specific packages for m1x
  home.packages = with pkgs; [ ];
}
