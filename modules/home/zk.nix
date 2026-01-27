{ ... }:
{
  programs.nixvim = {
    plugins.zk.enable = true;
    lsp.servers.zk.enable = true;
  };
  programs.zk = {
    enable = true;
    settings = {
      extra = {
        author = "Noe";
      };
    };
  };
}
