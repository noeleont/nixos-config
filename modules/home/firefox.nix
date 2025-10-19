{pkgs, ... }:

{
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
}
