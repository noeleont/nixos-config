{ config, pkgs, ... }:

{
  home.shellAliases = {
    grep = "grep --color";
    tf = "tofu";
    k = "kubectl";
    la = "exa -hal";
    ".." = "cd ..";
    "..." = "cd ../..";
  };
}
