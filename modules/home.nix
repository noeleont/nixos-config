{ pkgs, ... }:
{
  imports = [ ];

  home = {
    stateVersion = "25.05";
    file = { };

    packages = with pkgs; [
      fzf
      fd
      ripgrep
      wget
      # nvim-pkg
    ];
  };

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      sessionVariables = {
        EDITOR = "vim";
      };
      enableCompletion = true;
      history = {
        saveNoDups = true;
        ignoreAllDups = true;
      };
      shellAliases = {
        l = "ls -l";
        ".." = "cd ..";
      };
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          # TODO: patch file to use fzf history in insert mode
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "catppuccin_frappe";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      fileWidgetOptions = [
        "--preview 'head {}'"
      ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
