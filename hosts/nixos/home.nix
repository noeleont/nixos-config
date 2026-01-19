{ pkgs, pkgs-unstable, lib, ... }:

{

  imports = [
    ../../modules/home
    ../../modules/home/virtualization.nix
    ../../modules/home/kde.nix
  ];

  home.username = "noeleon";
  home.homeDirectory = "/home/noeleon";

  # System-specific packages for nixos
  home.packages = with pkgs; [
    android-studio
    wireshark
    nil
    discord
  ];


}
