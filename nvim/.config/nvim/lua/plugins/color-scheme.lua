local opts = {
  transparent_background = true,
  transparent = true,
  styles = { sidebars = "transparent", floats = "transparent" },
}

return {
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = opts },
  { "folke/tokyonight.nvim", name = "tokyonight", lazy = true, opts = opts },
  { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true, opts = opts },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
