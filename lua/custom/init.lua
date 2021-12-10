-- This is where your custom modules and plugins go.
-- See the wiki for a guide on how to extend NvChad

local hooks = require "core.hooks"

-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

-- hooks.override("lsp", "publish_diagnostics", function(current)
--   current.virtual_text = false;
--   return current;
-- end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- hooks.add("setup_mappings", function(map)
--    map("n", "<leader>cc", "gg0vG$d", opt) -- example to delete the buffer
--    .... many more mappings ....
-- end)

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

hooks.add("install_plugins", function(use)
   local plugin_settings = require("core.utils").load_config().plugins
   -- colorscheme
   use "marko-cerovac/material.nvim"

   -- quick navigation
   use {
      "phaazon/hop.nvim",
      branch = "v1", -- optional but strongly recommended
      config = function()
         -- you can configure Hop the way you like here; see :h hop-config
         require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
      end,
   }

   -- clipboard manager
   use {
      "AckslD/nvim-neoclip.lua",
      requires = { "tami5/sqlite.lua", module = "sqlite" },
      config = function()
         require("neoclip").setup {
            history = 50,
            enable_persistant_history = true,
            db_path = vim.fn.stdpath "data" .. "/databases/neoclip.sqlite3",
            filter = nil,
            preview = true,
            default_register = "+",
            content_spec_column = false,
            on_paste = {
               set_reg = true,
            },
            keys = {
               i = {
                  select = "<cr>",
                  paste = "<c-p>",
                  paste_behind = "<c-k>",
                  custom = {},
               },
               n = {
                  select = "<cr>",
                  paste = "p",
                  paste_behind = "P",
                  custom = {},
               },
            },
         }
      end,
   }

   use {
      "chentau/marks.nvim",
      config = function()
         require("marks").setup {
            -- whether to map keybinds or not. default true
            default_mappings = true,
            -- which builtin marks to show. default {}
            builtin_marks = { ".", "<", ">", "^" },
            -- whether movements cycle back to the beginning/end of buffer. default true
            cyclic = true,
            -- whether the shada file is updated after modifying uppercase marks. default false
            force_write_shada = false,
            -- how often (in ms) to redraw signs/recompute mark positions.
            -- higher values will have better performance but may cause visual lag,
            -- while lower values may cause performance penalties. default 150.
            refresh_interval = 250,
            -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
            -- marks, and bookmarks.
            -- can be either a table with all/none of the keys, or a single number, in which case
            -- the priority applies to all marks.
            -- default 10.
            sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
            -- disables mark tracking for specific filetypes. default {}
            excluded_filetypes = { "terminal", "TelescopePrompt" },
            -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
            -- sign/virttext. Bookmarks can be used to group together positions and quickly move
            -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
            -- default virt_text is "".
            bookmark_0 = {
               sign = "⚑",
               virt_text = "hello world",
            },
            mappings = {},
         }
      end,
   }

   -- version control (git, svn)
   if vim.fn.has "mac" == 1 then -- work computer
      use "mhinz/vim-signify"
   end

   --  formatters
   use "pappasam/vim-filetype-formatter"

   -- symbols
   use {
      "SmiteshP/nvim-gps",
      disable = not plugin_settings.status.feline,
      requires = "nvim-treesitter/nvim-treesitter",
      after = "nvim-treesitter",
      event = "BufRead",
      config = function()
         require("nvim-gps").setup()
      end,
   }

   -- highlight todo
   use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("todo-comments").setup {}
      end,
   }

   use {
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("neogit").setup {}
      end,
   }
   use "simrat39/symbols-outline.nvim"
end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"

vim.o.colorcolumn = "99"
vim.o.scrolloff = 999

-- hop keymapping
vim.api.nvim_set_keymap("", "f", "<cmd>lua require'hop'.hint_char1({})<cr>", {})

-- formatters
vim.g.vim_filetype_formatter_commands = {
   python = "black -q - | isort -q - | docformatter -",
   lua = "stylua -",
}

-- format on save
vim.api.nvim_exec(
   [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.jsx,*.tsx,*.js,*.ts,*.rs,*.lua,*.py FiletypeFormat
augroup END
]],
   true
)

-- split keymapping
vim.api.nvim_set_keymap("n", "<space>\\", "<cmd>vsplit<CR>", {})
vim.api.nvim_set_keymap("n", "<space>|", "<cmd>split<CR>", {})

-- open neogit
vim.api.nvim_set_keymap("n", "<space>git", "<cmd>Neogit<CR>", {})

-- outline settings
vim.g.symbols_outline = {
   relative_width = false,
   width = 40,
}
vim.api.nvim_set_keymap("n", "<space>n", "<cmd>SymbolsOutline<CR>", {})
