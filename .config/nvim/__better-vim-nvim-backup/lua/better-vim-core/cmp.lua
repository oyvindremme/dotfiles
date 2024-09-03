local cmp = require "cmp"
local luasnip = require "luasnip"
local helpers = require "better-vim-core.helpers"

local function should_load_snippets()
  local unload_plugins_table = helpers.get_config_item { "unload_plugins" }

  for _, k in pairs(unload_plugins_table) do
    if k == "snippets" then
      return false
    end
  end

  return true
end

if should_load_snippets() then
  require("luasnip.loaders.from_vscode").lazy_load()
end

luasnip.config.setup {}

local cmp_user_config = helpers.get_config_item { "cmp" }
local before_default_sources = cmp_user_config.before_default_sources or {}
local after_default_sources = cmp_user_config.after_default_sources or {}

local default_sources = {
  {
    name = "nvim_lsp",
    entry_filter = function(entry)
      if should_load_snippets() then
        return entry:get_kind()
      end

      return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
    end,
  },
  { name = "luasnip" },
}

local sources = helpers.merge_tables(before_default_sources, default_sources, after_default_sources)

local cmp_mappings = cmp_user_config.mappings or {}
local mappings = {
  scroll_docs_down = cmp_mappings.scroll_docs_down or "<C-d>",
  scroll_docs_up = cmp_mappings.scroll_docs_up or "<C-u>",
  next_item = cmp_mappings.next_item or "<C-n>",
  prev_item = cmp_mappings.prev_item or "<C-p>",
  show_list = cmp_mappings.show_list or "<C-Space>",
  confirm = cmp_mappings.confirm or "<CR>",
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered()
  },
  mapping = cmp.mapping.preset.insert {
    [mappings.scroll_docs_down] = cmp.mapping.scroll_docs(4),
    [mappings.scroll_docs_up] = cmp.mapping.scroll_docs(-4),
    [mappings.show_list] = cmp.mapping.complete {},
    [mappings.confirm] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    [mappings.next_item] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    [mappings.prev_item] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = sources,
}
