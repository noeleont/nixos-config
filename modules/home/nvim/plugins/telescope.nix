{
  plugins.telescope = {
    enable = true;

    extensions = {
      fzy-native.enable = true;
    };

    settings = {
      defaults = {
        path_display = [ "truncate" ];
        layout_strategy = "vertical";
        layout_config = {
          vertical = {
            width = ''
              function(_, max_columns)
                return math.floor(max_columns * 0.99)
              end
            '';
            height = ''
              function(_, _, max_lines)
                return math.floor(max_lines * 0.99)
              end
            '';
            prompt_position = "bottom";
            preview_cutoff = 0;
          };
        };

        mappings = {
          i = {
            "<C-q>" = "actions.send_to_qflist";
            "<C-l>" = "actions.send_to_loclist";
            "<C-s>" = "actions.cycle_previewers_next";
            "<C-a>" = "actions.cycle_previewers_prev";
          };
          n = {
            "q" = "actions.close";
          };
        };

        preview = {
          treesitter = true;
        };

        color_devicons = true;
        set_env = {
          COLORTERM = "truecolor";
        };
        prompt_prefix = "   ";
        selection_caret = "  ";
        entry_prefix = "  ";
        initial_mode = "insert";
        vimgrep_arguments = [
          "rg"
          "-L"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
        ];
      };
    };

    keymaps = {
      "<leader>tp" = {
        action = "find_files";
        options = {
          desc = "[t]elescope find files - ctrl[p] style";
        };
      };
      "<M-p>" = {
        action = "oldfiles";
        options = {
          desc = "[telescope] old files";
        };
      };
      "<C-g>" = {
        action = "live_grep";
        options = {
          desc = "[telescope] live grep";
        };
      };
      "<leader>tg" = {
        action = "git_files";
        options = {
          desc = "[t]elescope project files [g]";
        };
      };
      "<leader>tc" = {
        action = "quickfix";
        options = {
          desc = "[t]elescope quickfix list [c]";
        };
      };
      "<leader>tq" = {
        action = "command_history";
        options = {
          desc = "[t]elescope command history [q]";
        };
      };
      "<leader>tl" = {
        action = "loclist";
        options = {
          desc = "[t]elescope [l]oclist";
        };
      };
      "<leader>tr" = {
        action = "registers";
        options = {
          desc = "[t]elescope [r]egisters";
        };
      };
      "<leader>tbb" = {
        action = "buffers";
        options = {
          desc = "[t]elescope [b]uffers [b]";
        };
      };
      "<leader>tbf" = {
        action = "current_buffer_fuzzy_find";
        options = {
          desc = "[t]elescope current [b]uffer [f]uzzy find";
        };
      };
      "<leader>td" = {
        action = "lsp_document_symbols";
        options = {
          desc = "[t]elescope lsp [d]ocument symbols";
        };
      };
      "<leader>to" = {
        action = "lsp_dynamic_workspace_symbols";
        options = {
          desc = "[t]elescope lsp dynamic w[o]rkspace symbols";
        };
      };
      "<leader>*" = {
        action = "grep_string";
        options = {
          desc = "[telescope] grep current string [*]";
        };
      };
    };
  };

  # Custom telescope functions
  extraConfigLua = ''
    local builtin = require('telescope.builtin')
    local telescope = require('telescope')

    -- Fall back to find_files if not in a git repo
    local function project_files()
      local opts = {}
      local ok = pcall(builtin.git_files, opts)
      if not ok then
        builtin.find_files(opts)
      end
    end

    -- Grep the string under the cursor, filtering for the current file type
    local function grep_current_file_type(picker)
      local current_file_ext = vim.fn.expand('%:e')
      local additional_vimgrep_arguments = {}
      if current_file_ext ~= "" then
        additional_vimgrep_arguments = {
          '--type',
          current_file_ext,
        }
      end
      local conf = require('telescope.config').values
      picker {
        vimgrep_arguments = vim.tbl_flatten {
          conf.vimgrep_arguments,
          additional_vimgrep_arguments,
        },
      }
    end

    local function grep_string_current_file_type()
      grep_current_file_type(builtin.grep_string)
    end

    local function live_grep_current_file_type()
      grep_current_file_type(builtin.live_grep)
    end

    -- Fuzzy grep
    local function fuzzy_grep(opts)
      opts = vim.tbl_extend('error', opts or {}, { search = "", prompt_title = 'Fuzzy grep' })
      builtin.grep_string(opts)
    end

    local function fuzzy_grep_current_file_type()
      grep_current_file_type(fuzzy_grep)
    end

    -- Custom keymaps for functions not available via keymaps option
    vim.keymap.set('n', '<leader>tf', fuzzy_grep, { desc = '[t]elescope [f]uzzy grep' })
    vim.keymap.set('n', '<M-f>', fuzzy_grep_current_file_type, { desc = '[telescope] fuzzy grep filetype' })
    vim.keymap.set('n', '<M-g>', live_grep_current_file_type, { desc = '[telescope] live grep filetype' })
    vim.keymap.set('n', '<leader>t*', grep_string_current_file_type, { desc = '[t]elescope grep current string [*] in current filetype' })
  '';
}
