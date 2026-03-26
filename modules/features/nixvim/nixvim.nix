{ self, ... }:
{
  flake.nixosModules = {
    nixvim =
      {
        inputs,
        ...
      }:
      {
        imports = [ inputs.nixvim.nixosModules.nixvim ];
        programs.nixvim = {
          enable = true;
          imports = [ self.nixosModules.nixvim-conf ];
        };
      };
    nixvim-conf =
      { pkgs, lib, ... }:
      {
        imports = [
          ./config
          ./plugins
        ];
        config = {
          globals.mapleader = " ";

          clipboard.register = "unnamedplus";
          diagnostic.settings = {
            virtual_text = true;
          };

          filetype = {
            pattern = {
              "__rawKey__\".*/.github/workflows/.*%.yml\"" = "yaml.ghaction";
              "__rawKey__\".*/(data|assets)/\S+/.*%.json\"" = "json.mcdatapack";
            };
            extension = {
              mcfunction = "mcfunction";
              mcdoc = "mcdoc";
              bolt = "bolt";
              mcmeta = "json.mcmeta";
            };
          };

          opts = {
            number = true;
            relativenumber = true;
            shiftwidth = 2;
            tabstop = 2;
            wrap = false;
            swapfile = false;
            backup = false;
            undofile = true;
            hlsearch = true;
            incsearch = true;
            termguicolors = true;
            scrolloff = 8;
            signcolumn = "yes";
            updatetime = 50;
            foldlevelstart = 99;
            foldmethod = "expr";
            foldexpr.__raw = "vim.treesitter.foldexpr()";
            foldtext.__raw = ''vim.fn.getline(vim.v.foldstart) .. ' ... ' .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")'';
            fillchars = "eob: ,fold:·";
            expandtab = true;
            smartcase = true;
            ignorecase = true;
            shell = lib.getExe pkgs.nushell; # TODO: Change it for enviroment
          };
          extraPackages = with pkgs; [
            # base
            fzf
            ripgrep
            fd

            # Formatters
            stylua
            nixfmt
            nufmt
            astyle
            gdscript-formatter

            # Linters
            shellcheck # Shell script linter
            eslint_d # JavaScript/TypeScript linter
            statix
            vale
            markdownlint-cli2
            gdtoolkit_4

            # Lsps
            nixd
            nil
          ];

          extraConfigLuaPost = ''
            vim.treesitter.language.register('rust', 'mcdoc')
          '';
        };
      };
  };
}
