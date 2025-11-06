{
  plugins = {
    # Snippet engine
    luasnip = {
      enable = true;
    };

    # LSP kind icons
    lspkind = {
      enable = true;
      settings.mode = "symbol_text";
      cmp.enable = true;
    };

    # Autocompletion
    cmp = {
      enable = true;

      settings = {
        completion = {
          completeopt = "menu,menuone,noinsert";
        };

        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        mapping = {
          "<C-f>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.scroll_docs(4)
              else
                cmp.complete({ config = { sources = { { name = 'path' } } } })
              end
            end, { 'i', 'c', 's' })
          '';

          "<C-j>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require('luasnip')
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 'c', 's' })
          '';

          "<C-k>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require('luasnip')
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 'c', 's' })
          '';

          "<C-h>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.close()
              else
                cmp.complete()
              end
            end, { 'i', 'c', 's' })
          '';

          "<C-l>" = "cmp.mapping.confirm({ select = true })";
        };

        sources = [
          {
            name = "nvim_lsp";
            keyword_length = 3;
          }
          {
            name = "nvim_lsp_signature_help";
            keyword_length = 3;
          }
          { name = "path"; }
        ];

        experimental = {
          native_menu = false;
          ghost_text = true;
        };
      };

      # Filetype-specific sources
      filetype = {
        lua = {
          sources = [
            { name = "nvim_lua"; }
            {
              name = "nvim_lsp";
              keyword_length = 3;
            }
            { name = "path"; }
          ];
        };
      };

      # Command-line completion
      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {
              name = "nvim_lsp_document_symbol";
              keyword_length = 3;
            }
            { name = "buffer"; }
            { name = "cmdline_history"; }
          ];
        };

        "?" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {
              name = "nvim_lsp_document_symbol";
              keyword_length = 3;
            }
            { name = "buffer"; }
            { name = "cmdline_history"; }
          ];
        };

        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            { name = "cmdline"; }
            { name = "cmdline_history"; }
            { name = "path"; }
          ];
        };
      };
    };

    # CMP sources
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-cmdline.enable = true;
    cmp-cmdline-history.enable = true;
    cmp_luasnip.enable = true;
  };

  extraConfigLua = ''
    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
  '';
}
