local opts = {
  transparent_background = true,
  transparent = true,
  styles = { sidebars = "transparent", floats = "transparent" },
}

return {
  { "NLKNguyen/papercolor-theme", name = "papercolor", lazy = true },
  {
    "bluz71/vim-nightfly-guicolors",
    name = "nightfly",
    lazy = true,
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = opts },
  { "ellisonleao/gruvbox.nvim", name = "gruvbox", lazy = true },
  { "folke/tokyonight.nvim", name = "tokyonight", lazy = true, opts = opts },
  { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true, opts = opts },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "sainnhe/everforest", name = "everforrest", lazy = true },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
