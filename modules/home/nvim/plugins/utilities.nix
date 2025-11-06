{ pkgs, ... }:
{
  plugins = {
    which-key = {
      enable = true;
      settings = {
        preset = "helix";
      };
    };
  };
}
