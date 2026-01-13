{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    plugins-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
                        allowUnfree = true;
    };
    dependencyOverlays = /* (import ./overlays inputs) ++ */ [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
          tree-sitter
        ];
        lint = with pkgs; [
        ];
        debug = with pkgs; {
          go = [ delve ];
        };
        go = with pkgs; [
          gopls
          gotools
          go-tools
          gccgo
        ];
        format = with pkgs; [
        ];
        neonixdev = {
          inherit (pkgs) nix-doc lua-language-server nixd;
        };
                                js = with pkgs; [
                                        typescript-language-server
                                        tailwindcss-language-server
                                        vscode-langservers-extracted
                                        emmet-ls
                                ];
      };
      startupPlugins = {
        debug = with pkgs.vimPlugins; [
          nvim-nio
        ];
        general = with pkgs.vimPlugins; {
          always = [
            lze
            lzextras
            vim-repeat
            plenary-nvim
            (nvim-notify.overrideAttrs { doCheck = false; })
                                                no-neck-pain-nvim
                                                nvim-highlight-colors
                                                nvim-autopairs
                                                rainbow-delimiters-nvim
                                                vim-tmux-navigator
                                                nvim-ufo
          ];
          extra = [
            oil-nvim
            nvim-web-devicons
          ];
        };
        themer = with pkgs.vimPlugins;
          (builtins.getAttr (categories.colorscheme or "onedark") {
              # Theme switcher without creating a new category
              "onedark" = onedark-nvim;
              "catppuccin" = catppuccin-nvim;
              "catppuccin-mocha" = catppuccin-nvim;
              "tokyonight" = tokyonight-nvim;
              "tokyonight-day" = tokyonight-nvim;
            }
          );
      };
      optionalPlugins = {
        debug = with pkgs.vimPlugins; {
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
          go = [ nvim-dap-go ];
        };
        lint = with pkgs.vimPlugins; [
          nvim-lint
        ];
        format = with pkgs.vimPlugins; [
          conform-nvim
        ];
        markdown = with pkgs.vimPlugins; [
          markdown-preview-nvim
        ];
        neonixdev = with pkgs.vimPlugins; [
          lazydev-nvim
        ];
                                python = with pkgs.vimPlugins;[
                                        ale
                                        pyright
                                ];
        general = {
          blink = with pkgs.vimPlugins; [
            luasnip
            cmp-cmdline
            blink-cmp
            blink-compat
            colorful-menu-nvim
          ];
                                        cmp = with pkgs.vimPlugins;[
                                                nvim-cmp
                                                friendly-snippets
                                                cmp_luasnip
                                                cmp-buffer
                                                cmp-path
                                                cmp-nvim-lua
                                                cmp-nvim-lsp
                                                cmp-nvim-lsp-signature-help
                                                cmp-cmdline-history
                                                lspkind-nvim
                                                vim-dadbod
                                                vim-dadbod-completion
                                                vim-dadbod-ui
                                        ];
          treesitter = with pkgs.vimPlugins; [
            pkgs.neovimPlugins.treesitter-textobjects
            nvim-treesitter.withAllGrammars
          ];
          telescope = with pkgs.vimPlugins; [
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            telescope-nvim
          ];
          always = with pkgs.vimPlugins; [
            nvim-lspconfig
            lualine-nvim
            gitsigns-nvim
            vim-sleuth
            vim-fugitive
            vim-rhubarb
            nvim-surround
                                                html5-vim
                                                no-neck-pain-nvim
                                                nvim-highlight-colors
          ];
          extra = with pkgs.vimPlugins; [
            fidget-nvim
            which-key-nvim
            comment-nvim
            undotree
            indent-blankline-nvim
            vim-startuptime
          ];
        };
      };

      sharedLibraries = {
        general = with pkgs; [ # <- this would be included if any of the subcategories of general are
        ];
      };
      environmentVariables = {
        test = {
          default = {
            CATTESTVARDEFAULT = "It worked!";
          };
          subtest1 = {
            CATTESTVAR = "It worked!";
          };
          subtest2 = {
            CATTESTVAR3 = "It didn't work!";
          };
        };
      };
      extraWrapperArgs = {
        test = [
          '' --set CATTESTVAR2 "It worked again!"''
        ];
      };
      python3.libraries = {
        test = (_:[]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        general = [ (_:[]) ];
      };
      extraCats = {
        test = [
          [ "test" "default" ]
        ];
        debug = [
          [ "debug" "default" ]
        ];
        go = [
          [ "debug" "go" ] # yes it has to be a list of lists
        ];
      };
    };
    packageDefinitions = {
      nixCats = { pkgs, name, ... }@misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = [ "mvim" ];
          wrapRc = true;
          configDirName = "nixCats-nvim";
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          markdown = true;
          general = true;
          lint = true;
          format = true;
          neonixdev = true;
          test = {
            subtest1 = true;
          };
          lspDebugMode = true;
          themer = true;
                                        debug=true;
          colorscheme = "onedark";
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };
      regularCats = { pkgs, ... }@misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = false;
          configDirName = "nixCats-nvim";

          aliases = [ "testCat" ];
        };
        categories = {
          markdown = true;
          general = true;
          neonixdev = true;
          lint = true;
          format = true;
          test = true;
          lspDebugMode = false;
          themer = true;
          colorscheme = "catppuccin";
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
          };
          theBestCat = "says meow!!";
          theWorstCat = {
            thing'1 = [ "MEOW" '']]' ]=][=[HISSS]]"[['' ];
            thing2 = [
              {
                thing3 = [ "give" "treat" ];
              }
              "I LOVE KEYBOARDS"
              (utils.mkLuaInline ''[[I am a]] .. [[ lua ]] .. type("value")'')
            ];
            thing4 = "couch is for scratching";
          };
        };
      };
    };

    defaultPackageName = "nixCats";
  in
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in {
    packages = utils.mkAllWithDefault defaultPackage;

    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });

}
