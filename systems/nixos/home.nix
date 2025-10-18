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

  programs = {
    firefox = {
      enable = true;
      policies = {
        SearchEngines = {
          Add = [
            {
              Alias = "@np";
              Description = "Search in NixOS Packages";
              IconURL = "https://nixos.org/favicon.png";
              Method = "GET";
              Name = "NixOS Packages";
              URLTemplate = "https://search.nixos.org/packages?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
            }
            {
              Alias = "@no";
              Description = "Search in NixOS Options";
              IconURL = "https://nixos.org/favicon.png";
              Method = "GET";
              Name = "NixOS Options";
              URLTemplate = "https://search.nixos.org/options?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
            }
          ];
        };
      };
    };
  };

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
