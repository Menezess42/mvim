local catUtils = require('nixCatsUtils')
if (catUtils.isNixCats and nixCats('lspDebugMode')) then
  vim.lsp.set_log_level("debug")
end

local old_ft_fallback = require('lze').h.lsp.get_ft_fallback()
require('lze').h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    if not ok then
      ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end)
require('lze').load {
  {
    "nvim-lspconfig",
    for_cat = "general.always",
    on_require = { "lspconfig" },
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config('*', {
        on_attach = require('myLuaConf.LSPs.on_attach'),
      })
    end,
  },
  {
    "mason.nvim",
    enabled = not catUtils.isNixCats,
    on_plugin = { "nvim-lspconfig" },
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("mason-lspconfig.nvim")
      require('mason').setup()
      require('mason-lspconfig').setup { automatic_installation = true, }
    end,
  },
  {
    "lazydev.nvim",
    for_cat = "neonixdev",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require('lazydev').setup({
        library = {
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. '/lua' },
        },
      })
    end,
  },
  {
    "lua_ls",
    enabled = nixCats('lua') or nixCats('neonixdev') or false,
    lsp = {
      filetypes = { 'lua' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { "nixCats", "vim", },
            disable = { 'missing-fields' },
          },
          telemetry = { enabled = false },
        },
      },
    },
  },
  {
    "gopls",
    for_cat = "go",
    lsp = {
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
    },
  },
  {
    "rnix",
    enabled = not catUtils.isNixCats,
    lsp = {
      filetypes = { "nix" },
    },
  },
  {
    "nil_ls",
    enabled = not catUtils.isNixCats,
    lsp = {
      filetypes = { "nix" },
    },
  },
  {
    "nixd",
    enabled = catUtils.isNixCats and (nixCats('nix') or nixCats('neonixdev')) or false,
    lsp = {
      filetypes = { "nix" },
      settings = {
        nixd = {
          nixpkgs = {
            expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
          },
          options = {
            nixos = {
              expr = nixCats.extra("nixdExtras.nixos_options")
            },
            ["home-manager"] = {
              expr = nixCats.extra("nixdExtras.home_manager_options")
            }
          },
          formatting = {
            command = { "nixfmt" }
          },
          diagnostic = {
            suppress = {
              "sema-escaping-with"
            }
          }
        }
      },
    },
  },
        {
                "pyright",
                lsp = {
                        filetypes = { "python" },
                        settings = {
                                python = {
                                        analysis = {
                                                autoImportCompletions = true,
                                                typeCheckingMode = "basic",
                                                useLibraryCodeForTypes = true,
                                        },
                                },
                        },
                },
        },
        {
                "jedi_language_server",
                lsp = {
                        filetypes = { "python" },
                        settings = {
                                python = {
                                        completion = {
                                                enable = true,
                                                disableSnippets = true,
                                        },
                                        hover = {
                                                enable = true,
                                        },
                                        signature = {
                                                enable = true,
                                        },
                                },
                        },
                },
        },
        {
                "ts_ls",
                for_cat = "js",  -- equivalente ao seu if nixCats('js')
                lsp = {
                        filetypes = { "javascript", "typescript" },
                        settings = {
                                init_options = {
                                        preferences = {
                                                importModuleSpecifierPreference = "relative",
                                                quotePreference = "single",
                                        },
                                },
                        },
                },
        },
        {
                "html",
                for_cat = "js",
                lsp = {
                        filetypes = { "html" },
                        settings = {
                                html = {
                                        format = {
                                                enable = true,
                                        },
                                        hover = {
                                                documentation = true,
                                                references = true,
                                        },
                                        validate = true,
                                        suggest = {
                                                html5 = true,
                                        },
                                },
                        },
                },
        },
        {
                "cssls",
                for_cat = "js",
                lsp = {
                        filetypes = { "css", "scss", "less" },
                        settings = {
                                css = {
                                        validate = true,
                                        lint = {
                                                unknownAtRules = "ignore",
                                        },
                                },
                                scss = {
                                        validate = true,
                                },
                                less = {
                                        validate = true,
                                },
                        },
                },
        },
}
