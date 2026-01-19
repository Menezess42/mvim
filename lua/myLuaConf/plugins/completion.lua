local load_w_after = function(name)
    vim.cmd.packadd(name)
    vim.cmd.packadd(name .. '/after')
end

return {
    -- fontes
    { "cmp-buffer", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },
    { "cmp-path", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },
    { "cmp-cmdline", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },
    { "cmp-nvim-lsp", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },
    { "cmp-nvim-lsp-signature-help", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },
    { "cmp-nvim-lua", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },
    { "cmp_luasnip", for_cat = "general.cmp", on_plugin = { "nvim-cmp" }, load = load_w_after },

    { "friendly-snippets", for_cat = "general.cmp", dep_of = { "nvim-cmp" } },

    { "luasnip",
        for_cat = "general.cmp",
        dep_of = { "nvim-cmp" },
        after = function()
            local luasnip = require "luasnip"
            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.config.setup {}

            local ls = require("luasnip")
            vim.keymap.set({ "i", "s" }, "<M-n>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end)
        end,
    },

    {
        "nvim-cmp",
        for_cat = "general.cmp",
        event = "DeferredUIEnter",
        after = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false, -- <<< ISSO garante índice = -1 inicialmente
                    }),
                }),

                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "luasnip" },
                    { name = "buffer" },
                }),
            })

            -- cmdline /
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- cmdline :
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
-- local load_w_after = function(name)
--     vim.cmd.packadd(name)
--     vim.cmd.packadd(name .. '/after')
-- end
--
-- return {
--     {
--         "cmp-cmdline",
--         for_cat = "general.blink",
--         on_plugin = { "blink.cmp" },
--         load = load_w_after,
--     },
--     {
--         "blink.compat",
--         for_cat = "general.blink",
--         dep_of = { "cmp-cmdline" },
--     },
--     {
--         "luasnip",
--         for_cat = "general.blink",
--         dep_of = { "blink.cmp" },
--         after = function(_)
--             local luasnip = require 'luasnip'
--             require('luasnip.loaders.from_vscode').lazy_load()
--             luasnip.config.setup {}
--
--             local ls = require('luasnip')
--
--             vim.keymap.set({ "i", "s" }, "<M-n>", function()
--                 if ls.choice_active() then
--                     ls.change_choice(1)
--                 end
--             end)
--         end,
--     },
--     {
--         "colorful-menu.nvim",
--         for_cat = "general.blink",
--         on_plugin = { "blink.cmp" },
--     },
--     {
--         "blink.cmp",
--         for_cat = "general.blink",
--         event = "DeferredUIEnter",
--         after = function(_)
-- do
--     local blink = require("blink.cmp")
--
--     local orig_show = blink.show
--
--     blink.show = function(...)
--         orig_show(...)
--         vim.schedule(function()
--             pcall(function()
--                 -- força índice inválido
--                 blink.list.state.selected = nil
--                 -- força redraw
--                 blink.list.render()
--             end)
--         end)
--     end
-- end
--             require("blink.cmp").setup({
--                 keymap = {
--                         ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
--                         ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
--                         ['<CR>'] = {},
--                 },
--                 cmdline = {
--                     enabled = true,
--                     completion = {
--                         menu = {
--                             auto_show = true,
--                         },
--                     },
--                     sources = function()
--                         local type = vim.fn.getcmdtype()
--                         -- Search forward and backward
--                         if type == '/' or type == '?' then return { 'buffer' } end
--                         -- Commands
--                         if type == ':' or type == '@' then return { 'cmdline', 'cmp_cmdline' } end
--                         return {}
--                     end,
--                 },
--                 fuzzy = {
--                     sorts = {
--                         'exact',
--                         -- defaults
--                         'score',
--                         'sort_text',
--                     },
--                 },
--                 signature = {
--                     enabled = true,
--                     window = {
--                         show_documentation = true,
--                     },
--                 },
--                 completion = {
--                     list = {
--                         selection = {
--                             preselect = false,
--                             auto_insert = false,
--                         },
--                     },
--                     menu = {
--                         draw = {
--                             treesitter = { 'lsp' },
--                             components = {
--                                 label = {
--                                     text = function(ctx)
--                                         return require("colorful-menu").blink_components_text(ctx)
--                                     end,
--                                     highlight = function(ctx)
--                                         return require("colorful-menu").blink_components_highlight(ctx)
--                                     end,
--                                 },
--                             },
--                         },
--                     },
--                     documentation = {
--                         auto_show = true,
--                     },
--                 },
--                 snippets = {
--                     preset = 'luasnip',
--                     active = function(filter)
--                         local snippet = require "luasnip"
--                         local blink = require "blink.cmp"
--                         if snippet.in_snippet() and not blink.is_visible() then
--                             return true
--                         else
--                             if not snippet.in_snippet() and vim.fn.mode() == "n" then snippet.unlink_current() end
--                             return false
--                         end
--                     end,
--                 },
--                 sources = {
--                     default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
--                     providers = {
--                         path = {
--                             score_offset = 50,
--                         },
--                         lsp = {
--                             score_offset = 40,
--                         },
--                         snippets = {
--                             score_offset = 40,
--                         },
--                         cmp_cmdline = {
--                             name = 'cmp_cmdline',
--                             module = 'blink.compat.source',
--                             score_offset = -100,
--                             opts = {
--                                 cmp_name = 'cmdline',
--                             },
--                         },
--                     },
--                 },
--             })
--         end,
--     },
-- }
