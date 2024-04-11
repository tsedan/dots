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

  {
    "echasnovski/mini.starter",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VimEnter",
    opts = function()
      local logo = table.concat({
        "                                         ____   ",
        "                        ,--,           ,'  , `. ",
        "      ,---,           ,--.'|        ,-+-,.' _ | ",
        "  ,-+-. /  |     .---.|  |,      ,-+-. ;   , || ",
        " ,--.'|'   |   /.  ./|`--'_     ,--.'|'   |  || ",
        "|   |  ,'' | .-' . ' |,' ,'|   |   |  ,', |  |, ",
        "|   | /  | |/___/ \\: |'  | |   |   | /  | |--' ",
        "|   | |  | |.   \\  ' .|  | :   |   : |  | ,    ",
        "|   | |  |/  \\   \\   ''  : |__ |   : |  |/    ",
        "|   | |--'    \\   \\   |  | '.'||   | |`-'     ",
        "|   |/         \\   \\ |;  :    ;|   ;/         ",
        "'---'           '---' |  ,   / '---'            ",
        "                       ---`-'                   ",
      }, "\n")
      local pad = string.rep(" ", 0)
      local new_section = function(name, action, section)
        return { name = name, action = action, section = pad .. section }
      end

      local starter = require("mini.starter")
      --stylua: ignore
      local config = {
        evaluate_single = true,
        header = logo,
        items = {
          new_section("New file",        "ene | startinsert",                      "Files"),
          new_section("Find file",       "Telescope find_files",                   "Files"),
          new_section("Recent files",    "Telescope oldfiles",                     "Files"),
          new_section("Grep text",       "Telescope live_grep",                    "Files"),
          new_section("Session restore", [[lua require("persistence").load()]],    "Management"),
          new_section("Packages",        "Lazy",                                   "Management"),
          new_section("Quit",            "qa",                                     "Management"),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(pad .. "░ ", false),
          starter.gen_hook.aligning("center", "center"),
        },
      }
      return config
    end,
    config = function(_, config)
      -- close Lazy and re-open when starter is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniStarterOpened",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      local starter = require("mini.starter")
      starter.setup(config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local pad_footer = string.rep(" ", 0)
          starter.config.footer = pad_footer .. "⚡ " .. stats.count .. " plugins, " .. ms .. "ms"
          pcall(starter.refresh)
        end,
      })
    end,
  },
}
