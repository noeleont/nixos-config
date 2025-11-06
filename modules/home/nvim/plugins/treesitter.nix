{ pkgs, ... }:
{
  plugins = {
    treesitter = {
      enable = true;

      settings = {
        highlight = {
          enable = true;
          disable = ''
            function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KiB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end
          '';
        };
      };

      # Install all grammars
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

    # Treesitter textobjects
    treesitter-textobjects = {
      enable = true;

      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aC" = "@call.outer";
            "iC" = "@call.inner";
            "a#" = "@comment.outer";
            "i#" = "@comment.outer";
            "ai" = "@conditional.outer";
            "ii" = "@conditional.outer";
            "al" = "@loop.outer";
            "il" = "@loop.inner";
            "aP" = "@parameter.outer";
            "iP" = "@parameter.inner";
          };
          selection_modes = {
            "@parameter.outer" = "v"; # charwise
            "@function.outer" = "V"; # linewise
            "@class.outer" = "<c-v>"; # blockwise
          };
        };

        swap = {
          enable = true;
          swap_next = {
            "<leader>a" = "@parameter.inner";
          };
          swap_previous = {
            "<leader>A" = "@parameter.inner";
          };
        };

        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]P" = "@parameter.outer";
          };
          goto_next_end = {
            "]M" = "@function.outer";
            "]P" = "@parameter.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[P" = "@parameter.outer";
          };
          goto_previous_end = {
            "[M" = "@function.outer";
            "[P" = "@parameter.outer";
          };
        };

        lsp_interop = {
          enable = true;
          peek_definition_code = {
            "df" = "@function.outer";
            "dF" = "@class.outer";
          };
        };
      };
    };

    # Treesitter context - shows code context at top
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
      };
    };

    # Context-aware commenting
    ts-context-commentstring = {
      enable = true;
    };
  };

  # Tree-sitter based folding
  extraConfigLua = ''
    vim.g.skip_ts_context_comment_string_module = true
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  '';
}
