local M = {}

M.general = {
  n = {
    ["<leader>tt"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "Toggle transparency",
    },
    ["<leader>b"] = { " ", "Buffer" },
    ["<leader>bn"] = { "<cmd> enew <CR>", "New buffer" },
    ["<leader>bx"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
    ["<leader>bh"] = {
      function()
        require("nvchad.tabufline").move_buf(-1)
      end,
      "Move current buffer left",
    },
    ["<leader>bl"] = {
      function()
        require("nvchad.tabufline").move_buf(1)
      end,
      "Move current buffer right",
    },
    ["<leader>g"] = { " ", "Git" },
  },
  i = {
    ["jj"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
  },
}

M.lspconfig = {
  plugin = true,
  n = {
    ["<leader>co"] = {
      "<cmd> OrganizeImports <CR>",
      "Organize Imports",
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Run or continue the debugger",
    },
  },
}
return M
