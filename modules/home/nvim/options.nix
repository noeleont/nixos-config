{
  colorschemes.tokyonight.enable = true;

  opts = {
    # Search down into subfolders
    path = "**";

    # System clipboard integration
    clipboard = "unnamedplus";

    # Line numbers
    number = true;
    relativenumber = true;

    # UI enhancements
    cursorline = true;
    showmatch = true; # Highlight matching parentheses
    termguicolors = true;
    scrolloff = 999;

    # Search
    incsearch = true;
    hlsearch = true;

    # Spell checking
    spell = true;
    spelllang = "en";

    # Indentation (2 spaces)
    expandtab = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;

    # Folding
    foldenable = false;

    # History and undo
    history = 2000;
    undofile = true;

    # Splits
    splitright = true;
    splitbelow = true;

    # Command line
    cmdheight = 0;

    # Number formats (exclude octal)
    nrformats = "bin,hex";

    # Color column at 100 chars
    colorcolumn = "100";

    # Fill chars (use Unicode fold markers)
    fillchars = "eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸";

    # Performance
    lazyredraw = true;
  };

  globals = {
    # Editor config support
    editorconfig = true;
  };

  # Diagnostic configuration
  diagnostic.settings = {
    virtual_text = {
      prefix = "";
    };
    signs = {
      text = {
        error = "󰅚";
        warn = "⚠";
        info = "ⓘ";
        hint = "󰌶";
      };
    };
    update_in_insert = false;
    underline = true;
    severity_sort = true;
    float = {
      focusable = false;
      style = "minimal";
      border = "rounded";
      source = "if_many";
      header = "";
      prefix = "";
    };
  };

  # Enable native plugins
  extraConfigLua = ''
    -- Native plugins
    vim.cmd.filetype('plugin', 'indent', 'on')
    vim.cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

    -- Custom diagnostic virtual text formatting
    local function prefix_diagnostic(prefix, diagnostic)
      return string.format(prefix .. ' %s', diagnostic.message)
    end

    vim.diagnostic.config {
      virtual_text = {
        prefix = "",
        format = function(diagnostic)
          local severity = diagnostic.severity
          if severity == vim.diagnostic.severity.ERROR then
            return prefix_diagnostic('󰅚', diagnostic)
          end
          if severity == vim.diagnostic.severity.WARN then
            return prefix_diagnostic('⚠', diagnostic)
          end
          if severity == vim.diagnostic.severity.INFO then
            return prefix_diagnostic('ⓘ', diagnostic)
          end
          if severity == vim.diagnostic.severity.HINT then
            return prefix_diagnostic('󰌶', diagnostic)
          end
          return prefix_diagnostic('■', diagnostic)
        end,
      },
    }

    -- Let sqlite.lua know where to find sqlite
    vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
  '';
}
