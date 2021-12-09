-- https://nvchad.github.io/config/Lsp%20stuff
local M = {}

M.setup_lsp = function(attach, capabilities)
   local lspconfig = require "lspconfig"

   -- replace the default lsp diagnostic symbols
   --    local function lspSymbol(name, icon)
   --       vim.fn.sign_define("DiagnosticSign" .. name, { text = icon, numhl = "DiagnosticDefault" .. name })
   --    end
   --
   --    lspSymbol("Error", "")
   --    lspSymbol("Information", "")
   --    lspSymbol("Hint", "")
   --    lspSymbol("Warning", "")

   -- lspservers with default config

   local servers = { "cssls", "pyright" }

   for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
         on_attach = attach,
         capabilities = capabilities,
         flags = {
            debounce_text_changes = 150,
         },
      }
   end

   -- typescript

   lspconfig.tsserver.setup {
      on_attach = function(client, bufnr)
         client.resolved_capabilities.document_formatting = false
         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
      end,
   }
   -- the above tsserver config will remove the tsserver's inbuilt formatting
   -- since I use null-ls with denofmt for formatting ts/js stuff.

   -- lua
   -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
   local sumneko_bin_path = "/usr/bin"
   local sumneko_main_path = "/usr/lib/lua-language-server"

   if vim.fn.has "mac" == 1 then -- work computer
      sumneko_bin_path = "/Users/duy/tools/lua-language-server/bin/macOS"
      sumneko_main_path = "/Users/duy/tools/lua-language-server/bin/macOS"
   end

   local runtime_path = vim.split(package.path, ";")
   table.insert(runtime_path, "lua/?.lua")
   table.insert(runtime_path, "lua/?/init.lua")

   lspconfig.sumneko_lua.setup {
      on_attach = attach,
      capabilities = capabilities,
      flags = {
         debounce_text_changes = 150,
      },
      cmd = { sumneko_bin_path .. "/lua-language-server", "-E", sumneko_main_path .. "/main.lua" },
      settings = {
         Lua = {
            runtime = {
               -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
               version = "LuaJIT",
               -- Setup your lua path
               path = runtime_path,
            },
            diagnostics = {
               -- Get the language server to recognize the `vim` global
               globals = { "vim" },
            },
            workspace = {
               -- Make the server aware of Neovim runtime files
               library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
               enable = false,
            },
         },
      },
   }
end

return M
