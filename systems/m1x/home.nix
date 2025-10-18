{ pkgs, ... }:

{

  imports = [
    ../../modules/home.nix
    ../../modules/home/shell.nix
    ../../modules/home/git.nix
    ../../modules/home/packages.nix
    ../../modules/home/virtualization.nix
  ];

  home.username = "noeleon";
  home.homeDirectory = "/home/noeleon";

  # System-specific packages for m1x
  home.packages = with pkgs; [
    firefox
    chromium
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh"
    ];
  };
}
