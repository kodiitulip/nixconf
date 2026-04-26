{
  flake.nixosModules.nixvim-conf =
    { lib, ... }:
    {
      plugins.bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            mode = "buffers";
            close_command = lib.nixvim.utils.mkRaw "function(n) Snacks.bufdelete(n) end";
            right_mouse_command = lib.nixvim.utils.mkRaw "function(n) Snacks.bufdelete(n) end";
            always_show_bufferline = false;

            close_icon = " ";
            buffer_close_icon = " ";
            modified_icon = " ";

            offsets = [
              {
                filetype = "snacks_layout_box";
              }
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "]b";
          action = "<cmd>BufferLineCycleNext<cr>";
          options = {
            desc = "Cycle to next buffer";
          };
        }

        {
          mode = "n";
          key = "[b";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options = {
            desc = "Cycle to previous buffer";
          };
        }

        {
          mode = "n";
          key = "<S-l>";
          action = "<cmd>BufferLineCycleNext<cr>";
          options = {
            desc = "Cycle to next buffer";
          };
        }

        {
          mode = "n";
          key = "<S-h>";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options = {
            desc = "Cycle to previous buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>bd";
          action = "<cmd>lua Snacks.bufdelete()<cr>";
          options = {
            desc = "Delete buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>bD";
          action = "<cmd>:bd<cr>";
          options = {
            desc = "Delete buffer and window";
          };
        }

        {
          mode = "n";
          key = "<leader>br";
          action = "<cmd>BufferLineCloseRight<cr>";
          options = {
            desc = "Delete buffers to the right";
          };
        }

        {
          mode = "n";
          key = "<leader>bl";
          action = "<cmd>BufferLineCloseLeft<cr>";
          options = {
            desc = "Delete buffers to the left";
          };
        }

        {
          mode = "n";
          key = "<leader>bo";
          action = "<cmd>lua Snacks.bufdelete.other()<cr>";
          options = {
            desc = "Delete other buffers";
          };
        }

        {
          mode = "n";
          key = "<leader>bp";
          action = "<cmd>BufferLineTogglePin<cr>";
          options = {
            desc = "Toggle pin";
          };
        }

        {
          mode = "n";
          key = "<leader>bP";
          action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
          options = {
            desc = "Delete non-pinned buffers";
          };
        }
      ];
    };
}
