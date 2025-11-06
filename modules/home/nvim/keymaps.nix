{
  keymaps = [
    {
      mode = "n";
      key = "Y";
      action = "y$";
      options = {
        silent = true;
        desc = "[Y]ank to end of line";
      };
    }

    # Buffer list navigation
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<CR>";
      options = {
        silent = true;
        desc = "previous [b]uffer";
      };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<CR>";
      options = {
        silent = true;
        desc = "next [b]uffer";
      };
    }
    {
      mode = "n";
      key = "[B";
      action = "<cmd>bfirst<CR>";
      options = {
        silent = true;
        desc = "first [B]uffer";
      };
    }
    {
      mode = "n";
      key = "]B";
      action = "<cmd>blast<CR>";
      options = {
        silent = true;
        desc = "last [B]uffer";
      };
    }

    # Moving lines in visual mode
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options = {
        silent = true;
        desc = "Move line down";
      };
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options = {
        silent = true;
        desc = "Move line up";
      };
    }

    # Tab management
    {
      mode = "n";
      key = "<space>tn";
      action = "<cmd>tabnew<CR>";
      options = {
        desc = "[t]ab: [n]ew";
      };
    }
    {
      mode = "n";
      key = "<space>tq";
      action = "<cmd>tabclose<CR>";
      options = {
        desc = "[t]ab: [q]uit/close";
      };
    }

    # Terminal mode escape
    {
      mode = "t";
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options = {
        desc = "switch to normal mode";
      };
    }
    {
      mode = "t";
      key = "<C-Esc>";
      action = "<Esc>";
      options = {
        desc = "send Esc to terminal";
      };
    }

    # Centered scrolling
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options = {
        desc = "move [d]own half-page and center";
      };
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options = {
        desc = "move [u]p half-page and center";
      };
    }
    {
      mode = "n";
      key = "<C-f>";
      action = "<C-f>zz";
      options = {
        desc = "move DOWN [f]ull-page and center";
      };
    }
    {
      mode = "n";
      key = "<C-b>";
      action = "<C-b>zz";
      options = {
        desc = "move UP full-page and center";
      };
    }
  ];

  # Complex keymaps that require Lua functions
  extraConfigLua = ''
    local api = vim.api
    local fn = vim.fn
    local keymap = vim.keymap
    local diagnostic = vim.diagnostic

    -- Toggle the quickfix list
    local function toggle_qf_list()
      local qf_exists = false
      for _, win in pairs(fn.getwininfo() or {}) do
        if win['quickfix'] == 1 then
          qf_exists = true
        end
      end
      if qf_exists == true then
        vim.cmd.cclose()
        return
      end
      if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd.copen()
      end
    end

    keymap.set('n', '<C-c>', toggle_qf_list, { desc = 'toggle quickfix list' })

    -- Helper for fallback notifications
    local function try_fallback_notify(opts)
      local success, _ = pcall(opts.try)
      if success then
        return
      end
      success, _ = pcall(opts.fallback)
      if success then
        return
      end
      vim.notify(opts.notify, vim.log.levels.INFO)
    end

    -- Cycle the quickfix list
    local function cleft()
      try_fallback_notify {
        try = vim.cmd.cprev,
        fallback = vim.cmd.clast,
        notify = 'Quickfix list is empty!',
      }
    end

    local function cright()
      try_fallback_notify {
        try = vim.cmd.cnext,
        fallback = vim.cmd.cfirst,
        notify = 'Quickfix list is empty!',
      }
    end

    keymap.set('n', '[c', cleft, { silent = true, desc = '[c]ycle quickfix left' })
    keymap.set('n', ']c', cright, { silent = true, desc = '[c]ycle quickfix right' })
    keymap.set('n', '[C', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry' })
    keymap.set('n', ']C', vim.cmd.clast, { silent = true, desc = 'last quickfix entry' })

    -- Cycle the location list
    local function lleft()
      try_fallback_notify {
        try = vim.cmd.lprev,
        fallback = vim.cmd.llast,
        notify = 'Location list is empty!',
      }
    end

    local function lright()
      try_fallback_notify {
        try = vim.cmd.lnext,
        fallback = vim.cmd.lfirst,
        notify = 'Location list is empty!',
      }
    end

    keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle [l]oclist left' })
    keymap.set('n', ']l', lright, { silent = true, desc = 'cycle [l]oclist right' })
    keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first [L]oclist entry' })
    keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last [L]oclist entry' })

    -- Resize windows
    local toIntegral = math.ceil
    keymap.set('n', '<leader>w+', function()
      local curWinWidth = api.nvim_win_get_width(0)
      api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
    end, { silent = true, desc = 'inc window [w]idth' })

    keymap.set('n', '<leader>w-', function()
      local curWinWidth = api.nvim_win_get_width(0)
      api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
    end, { silent = true, desc = 'dec window [w]idth' })

    keymap.set('n', '<leader>h+', function()
      local curWinHeight = api.nvim_win_get_height(0)
      api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
    end, { silent = true, desc = 'inc window [h]eight' })

    keymap.set('n', '<leader>h-', function()
      local curWinHeight = api.nvim_win_get_height(0)
      api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
    end, { silent = true, desc = 'dec window [h]eight' })

    -- Close floating windows
    keymap.set('n', '<leader>fq', function()
      vim.cmd('fclose!')
    end, { silent = true, desc = '[f]loating windows: [q]uit/close all' })

    -- Expand to current buffer's directory in command mode
    keymap.set('c', '%%', function()
      if fn.getcmdtype() == ':' then
        return fn.expand('%:h') .. '/'
      else
        return '%%'
      end
    end, { expr = true, desc = "expand to current buffer's directory" })

    -- Diagnostic navigation
    local severity = diagnostic.severity

    keymap.set('n', '<space>e', function()
      local _, winid = diagnostic.open_float(nil, { scope = 'line' })
      if not winid then
        vim.notify('no diagnostics found', vim.log.levels.INFO)
        return
      end
      vim.api.nvim_win_set_config(winid or 0, { focusable = true })
    end, { noremap = true, silent = true, desc = 'diagnostics floating window' })

    keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'previous [d]iagnostic' })
    keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'next [d]iagnostic' })

    keymap.set('n', '[e', function()
      diagnostic.goto_prev { severity = severity.ERROR }
    end, { noremap = true, silent = true, desc = 'previous [e]rror diagnostic' })

    keymap.set('n', ']e', function()
      diagnostic.goto_next { severity = severity.ERROR }
    end, { noremap = true, silent = true, desc = 'next [e]rror diagnostic' })

    keymap.set('n', '[w', function()
      diagnostic.goto_prev { severity = severity.WARN }
    end, { noremap = true, silent = true, desc = 'previous [w]arning diagnostic' })

    keymap.set('n', ']w', function()
      diagnostic.goto_next { severity = severity.WARN }
    end, { noremap = true, silent = true, desc = 'next [w]arning diagnostic' })

    keymap.set('n', '[h', function()
      diagnostic.goto_prev { severity = severity.HINT }
    end, { noremap = true, silent = true, desc = 'previous [h]int diagnostic' })

    keymap.set('n', ']h', function()
      diagnostic.goto_next { severity = severity.HINT }
    end, { noremap = true, silent = true, desc = 'next [h]int diagnostic' })

    -- Toggle diagnostics for buffer
    local function buf_toggle_diagnostics()
      local filter = { bufnr = api.nvim_get_current_buf() }
      diagnostic.enable(not diagnostic.is_enabled(filter), filter)
    end

    keymap.set('n', '<space>dt', buf_toggle_diagnostics, { desc = 'toggle diagnostics' })

    -- Toggle spell check
    local function toggle_spell_check()
      vim.opt.spell = not (vim.opt.spell:get())
    end

    keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })
  '';
}
