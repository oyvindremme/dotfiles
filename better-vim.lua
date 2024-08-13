return {
  lsps = {
    phpactor = {},
    ast_grep = {},
    mdx_analyzer = {}
 },
  treesitter = "all",
  theme = {
    name = "catppuccin"
  },
  dashboard = {
    header = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]]
    }
  },
  hooks = {
    after_setup = function()
      vim.o.wrap = true
      vim.o.relativenumber = true
    end,
  },
  mappings = {
    by_mode = {
      i = {
        vim.api.nvim_create_user_command('RemoveCR', ':%s/\\r//g', {})
      },
    },
    custom = {
      ["<C-d>"] = {
        "<C-d>zz",
        "Center cursor after scroll down"
      },
      ["<C-u>"] = {
        "<C-u>zz",
        "Center cursor after scroll down"
      }

    }
  },
  plugins = {
    "github/copilot.vim"
  }
}

