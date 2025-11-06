{ pkgs, ... }:
{
  plugins = {
    # Surround text objects with brackets, quotes, etc.
    nvim-surround = {
      enable = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-unimpaired # Bracket navigation
  ];
}
