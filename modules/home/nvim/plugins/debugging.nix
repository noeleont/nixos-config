{ pkgs, ... }:
{
  plugins = {
    dap = {
      enable = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    nvim-dap-ui
    nvim-dap-virtual-text
    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion
  ];
}
