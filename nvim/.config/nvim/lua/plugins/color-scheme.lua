return {
  { "NLKNguyen/papercolor-theme", name = "papercolor", lazy = true },
  { "bluz71/vim-nightfly-guicolors", name = "nightfly", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "ellisonleao/gruvbox.nvim", name = "gruvbox", lazy = true },
  { "folke/tokyonight.nvim", name = "tokyonight", lazy = true },
  { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "sainnhe/everforest", name = "everforrest", lazy = true },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
