{ pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home.username = "noeleon";
  home.homeDirectory = "/home/noeleon";

  # System-specific packages for m1x
  home.packages = with pkgs; [ ];
}
