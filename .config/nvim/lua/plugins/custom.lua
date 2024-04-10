return {
  -- configure color theme
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        keywords = { bold = true },
        functions = { bold = true },
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none
      end,
    },
  },

  -- use color theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
