return {
  "ferisjuan/cmp-pddl",
  dependencies = { "hrsh7th/nvim-cmp" },
  lazy = false,
  build = function()
    vim.loader.reset()
  end,
  config = function()
    vim.loader.reset()
    require("cmp_pddl.commands").setup()
  end,
}
