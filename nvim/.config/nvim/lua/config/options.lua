-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.terminal_emulator = "ghostty"
vim.g.lazyvim_mini_snippets_in_completion = true
vim.g.terminal_emulator = "ghostty"
vim.g.lazyvim_prettier_needs_config = true

-- ruby
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"
vim.filetype.add({
  filename = {
    ["Podfile"] = "ruby",
    ["Podfile.lock"] = "ruby",
  },
})

-- use fzf
vim.opt.rtp:append("/opt/homebrew/opt/fzf")

-- Force UTF-8 position encoding for all LSP clients
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
