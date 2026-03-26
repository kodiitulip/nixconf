{ lib, ... }:
{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      defaults = { };
      spec = [
        (
          lib.nixvim.utils.listToUnkeyedAttrs [
            {
              __unkeyed-1 = "<leader><tab>";
              group = "tabs";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "code";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "debug";
            }
            {
              __unkeyed-1 = "<leader>dp";
              group = "profiler";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "file/find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "git";
            }
            {
              __unkeyed-1 = "<leader>gh";
              group = "hunks";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "quit/session";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "search";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "ui";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "diagnostics/quickfix";
            }
            {
              __unkeyed-1 = "[";
              group = "prev";
            }
            {
              __unkeyed-1 = "]";
              group = "next";
            }
            {
              __unkeyed-1 = "g";
              group = "goto";
            }
            {
              __unkeyed-1 = "gs";
              group = "surround";
            }
            {
              __unkeyed-1 = "z";
              group = "fold";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "buffer";
              expand.__raw = ''
                function()
                  return require("which-key.extras").expand.buf()
                end'';
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "windows";
              proxy = "<c-w>";
              expand.__raw = ''
                function()
                  return require("which-key.extras").expand.win()
                end'';
            }
            {
              __unkeyed-1 = "gx";
              desc = "Open with system app";
            }
            {
              __unkeyed-1 = "<leader>t";
              desc = "Treesitter Movements";
            }
            {
              __unkeyed-1 = "<leader>tn";
              desc = "+Swap next";
            }
            {
              __unkeyed-1 = "<leader>tp";
              desc = "+Swap previous";
            }
          ]
          // {
            mode = [
              "n"
              "x"
            ];
          }
        )
      ];
    };
  };
  keymaps = [
    {
      key = "<leader>?";
      action = lib.nixvim.utils.mkRaw ''
        function()
          require("which-key").show({ global = false })
        end
      '';
      options.desc = "Buffer Local Keymaps (which-key)";
    }
  ];
}
