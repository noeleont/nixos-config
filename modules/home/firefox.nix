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
            {
              Alias = "@ho";
              Description = "Search in Home Manager Options";
              IconURL = "https://nixos.org/favicon.png";
              Method = "GET";
              Name = "Home Manager Options";
              URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
            }
            {
              Alias = "@gh";
              Description = "Search on GitHub";
              IconURL = "https://github.com/favicon.ico";
              Method = "GET";
              Name = "GitHub";
              URLTemplate = "https://github.com/search?q={searchTerms}";
            }
          ];
        };
      };
    };
  };
}
