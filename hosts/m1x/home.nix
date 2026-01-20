{ pkgs, ... }:

{
  imports = [
    ../../modules/home
    ../../modules/home/ui.nix
  ];

  home.username = "noeleon";
  home.homeDirectory = "/home/noeleon";

  kde.krohnkite.screenGap = 10;

  # System-specific packages for m1x
  home.packages = with pkgs; [ ];
}
