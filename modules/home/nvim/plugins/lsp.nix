{
  plugins.lsp = {
    enable = true;

    servers = {
      # Rust Language Server
      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };

      # Lua Language Server
      lua_ls = {
        enable = true;
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT";
            };
            diagnostics = {
              globals = [
                "vim"
                "describe"
                "it"
                "assert"
                "stub"
              ];
              disable = [
                "duplicate-set-field"
              ];
            };
            workspace = {
              checkThirdParty = false;
            };
            telemetry = {
              enable = false;
            };
            hint = {
              enable = true;
            };
          };
        };
      };

      # Nix Language Server
      nil_ls = {
        enable = true;
        settings = {
          nil = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };

      # Go Language Server
      gopls = {
        enable = true;
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
      };

      # Python Language Server
      pyright = {
        enable = true;
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true;
              useLibraryCodeForTypes = true;
            };
          };
        };
      };

      # TypeScript Language Server
      ts_ls = {
        enable = true;
      };

      # YAML Language Server
      yamlls = {
        enable = true;
      };

      # Terraform Language Server
      terraformls = {
        enable = true;
      };

      # Helm Language Server
      helm_ls = {
        enable = true;
      };
    };
  };

  # Additional filetype-specific configurations
  extraConfigLua = ''
    -- Lua filetype specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua",
      callback = function()
        vim.bo.comments = ':---,:--'
      end,
    })
  '';
}
