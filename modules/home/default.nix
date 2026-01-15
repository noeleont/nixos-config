{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./jujutsu.nix
    ./firefox.nix
    ./zed
    ./packages.nix
  ];

  home = {
    stateVersion = "25.05";
    file = { };

    packages = with pkgs; [
      fzf
      fd
      ripgrep
      bat
      wget
      # nvim-pkg
    ];
  };

  programs = {
    home-manager.enable = true;

    nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      imports = [ ./nvim ];
    };

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
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      initContent = ''
        # Re-initialize fzf keybindings after zsh-vi-mode to enable fzf history search (Ctrl+R) in insert mode
        function zvm_after_init() {
          zvm_bindkey viins '^R' fzf-history-widget
          zvm_bindkey viins '^F' fzf-ripgrep-widget
        }

        # Interactive ripgrep search with fzf
        fzf-ripgrep-widget() {
          local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
          local INITIAL_QUERY="''${*:-}"

          while true; do
            local result=$(
              RG_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' || true" \
              fzf --ansi \
                  --disabled \
                  --bind "start:reload:$RG_PREFIX {q} || true" \
                  --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
                  --query "$INITIAL_QUERY" \
                  --delimiter : \
                  --preview 'bat --color=always {1} --highlight-line {2}' \
                  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
                  --print-query)

            # Extract query and selected item
            local query=$(echo "$result" | head -n1)
            local selected=$(echo "$result" | tail -n1)

            # If no item selected (ESC pressed), break the loop
            [[ "$query" == "$selected" ]] && break

            # Update query for next iteration
            INITIAL_QUERY="$query"

            # Extract file and line number
            local file=$(echo "$selected" | cut -d: -f1)
            local line=$(echo "$selected" | cut -d: -f2)

            # Open vim at the specific line
            vim "+$line" "$file"

            # After vim closes, the loop continues and fzf reopens with the same query
          done

          zle reset-prompt
        }

        zle -N fzf-ripgrep-widget
      '';
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
