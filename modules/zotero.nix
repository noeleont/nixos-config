{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    zotero
  ];
  programs = {
    firefox = {
      policies = {
        ExtensionSettings = {
          "zotero@chnm.gmu.edu" = {
            default_area = "menupanel";
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };
      };
    };
  };
}
