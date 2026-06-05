return {
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 30000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd("colorscheme rose-pine")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd("colorscheme rose-pine-dawn")
      end,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
}
