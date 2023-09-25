local M = {}

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
