{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "*.swp"
      "devenv.nix"
      "devenv.lock"
      ".envrc"
      ".devenv"
      ".devenv.flake.nix"
    ];
    settings = {
      user = {
        name = "Noe Thalheim";
        email = "noe@thalheim.email";
      };
      core = {
        pager = "delta --line-numbers --dark --side-by-side";
        editor = "vim";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };
      format = {
        pretty = "%C(blue)%h%Creset %s %C(green)%d%Creset [%C(red)%an%Creset, %C(cyan)%cr%Creset] %C(bold reverse)%N%Creset";
      };
      branch = {
        autosetuprebase = "always";
      };
    };
  };
}
