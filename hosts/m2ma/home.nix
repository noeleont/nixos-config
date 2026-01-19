{ pkgs, config, ... }:
{
  imports = [
    ../../modules/home
  ];

  home.packages = with pkgs; [
    nodejs_20
  ];

  programs = {
    awscli.enable = true;
  };

  programs.zsh.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityAgent = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
    };
  };
}
