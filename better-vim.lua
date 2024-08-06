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
  }
}

