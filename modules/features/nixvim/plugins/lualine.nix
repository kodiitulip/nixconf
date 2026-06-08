{
  flake.nixosModules.nixvim-conf = {
    extraConfigLuaPre = ''
      local lint_progress = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
            return "󰦕"
        end
        return "󱉶 " .. table.concat(linters, ", ")
      end
    '';
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          extensions = [
            "fzf"
            "neo-tree"
          ];
          disabledFiletypes = {
            statusline = [
              "startup"
              "alpha"
            ];
          };
          theme = "rose-pine";
        };
        sections = {
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              icon = "";
            }
          ];
          lualine_b = [
            {
              __unkeyed-1 = "branch";
              icon = "";
            }
            {
              __unkeyed-1 = "diff";
              symbols = {
                added = " ";
                modified = " ";
                removed = " ";
              };
            }
          ];
          lualine_c = [
            {
              __unkeyed-1 = "filename";
              symbols = {
                modified = "";
                readonly = "";
                unnamed = "";
                newfile = "";
              };
            }
            {
              __unkeyed-1 = "filetype";
              icon_only = true;
              separator = "";
              padding = {
                left = 1;
                right = 0;
              };
            }
            {
              __unkeyed-1 = "navic";
            }
          ];
          lualine_x = [
            {
              __unkeyed-1 = "diagnostics";
              sources = [
                "nvim_lsp"
                "nvim_diagnostic"
                "nvim_workspace_diagnostic"
              ];
              symbols = {
                error = " ";
                warn = " ";
                info = " ";
                hint = "󰝶 ";
              };
              update_in_insert = true;
            }
            {
              __unkeyed-1 = "lint_progress";
            }
            {
              __unkeyed-1 = "lsp_status";
            }
          ];
          lualine_y = [
            {
              __unkeyed-1 = "progress";
            }
          ];
          lualine_z = [
            {
              __unkeyed-1 = "location";
            }
          ];
        };
      };
    };
  };
}
