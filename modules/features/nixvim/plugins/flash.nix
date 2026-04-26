{
  flake.nixosModules.nixvim-conf = _: {
    plugins.flash = {
      enable = true;
      settings = {
        label = {
          uppercase = false;
          rainbow.enabled = true;
        };
        jump = {
          nohlsearch = true;
          autojump = true;
        };
        prompt.prefix = [
          [
            "󱐋"
            "FlashPromptIcon"
          ]
        ];
        modes.search.enabled = true;
      };
    };
    keymaps = [
      {
        key = "s";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        key = "S";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
      {
        key = "r";
        mode = [ "o" ];
        action.__raw = ''function() require("flash").remote() end'';
        options.desc = "Remote Flash";
      }
      {
        key = "R";
        mode = [
          "x"
          "o"
        ];
        action.__raw = ''function() require("flash").treesitter_search() end'';
        options.desc = "Treesitter Search";
      }
      {
        key = "<c-s>";
        mode = [ "c" ];
        action.__raw = ''function() require("flash").toggle() end'';
        options.desc = "Toggle Flash Search";
      }
      {
        key = "<c-space>";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''
          function()
            require("flash").treesitter({
              actions = {
                ["<c-space>"] = "next",
                ["<BS>"] = "prev"
              }
            }) 
          end'';
        options.desc = "Treesitter Incremental Selection";
      }
    ];
  };
}
