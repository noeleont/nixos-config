{ pkgs, lib, ... }:

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

  # System-specific packages for nixos
  home.packages = with pkgs; [
    android-studio
    wireshark
    nil
    devenv
    discord
  ];

  

  xdg.configFile."zed/themes/1984.json" = {
    source = ./theme.json;
  };

  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "elixir"
      "make"
    ];

    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      vim_mode = true;

      theme = {
        mode = "dark";
        light = "One Light";
        dark = "1984 Cyberpunk";
      };

      ui_font_size = 16;
      buffer_font_size = 12;
      autosave = "on_focus_change";
    };
  };
}
