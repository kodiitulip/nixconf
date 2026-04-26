{
  flake.nixosModules.nixvim-conf =
    { lib, ... }:
    {
      keymaps = [
        # better up/down
        {
          mode = [
            "n"
            "x"
          ];
          key = "j";
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            desc = "Down";
            expr = true;
            silent = true;
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<down>";
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            desc = "Down";
            expr = true;
            silent = true;
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "k";
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            desc = "Up";
            expr = true;
            silent = true;
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<up>";
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            desc = "Up";
            expr = true;
            silent = true;
          };
        }

        # Move to window using the <ctrl> hjkl keys
        {
          mode = [ "n" ];
          key = "<c-h>";
          action = "<c-w>h";
          options = {
            desc = "Go to Left Window";
            remap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<c-j>";
          action = "<c-w>j";
          options = {
            desc = "Go to Down Window";
            remap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<c-k>";
          action = "<c-w>k";
          options = {
            desc = "Go to Up Window";
            remap = true;
          };
        }
        {
          mode = [ "n" ];
          key = "<c-l>";
          action = "<c-w>l";
          options = {
            desc = "Go to Right Window";
            remap = true;
          };
        }

        # Resize windows with <ctrl> arrow keys

        {
          mode = [ "n" ];
          key = "<C-Up>";
          action = "<cmd>resize +2<cr>";
          options.desc = "Increase Window Height";
        }
        {
          mode = [ "n" ];
          key = "<C-Down>";
          action = "<cmd>resize -2<cr>";
          options.desc = "Decrease Window Height";
        }
        {
          mode = [ "n" ];
          key = "<C-Left>";
          action = "<cmd>vertical resize -2<cr>";
          options.desc = "Decrease Window Width";
        }
        {
          mode = [ "n" ];
          key = "<C-Right>";
          action = "<cmd>vertical resize +2<cr>";
          options.desc = "Increase Window Width";
        }

        # Misc

        {
          key = "<leader>p";
          mode = [ "n" ];
          action = "<cmd>YankyRingHistory<CR>";
        }
        {
          key = "<c-s>";
          mode = [
            "i"
            "x"
            "n"
            "s"
          ];
          action = "<cmd>w<cr><esc>";
          options.desc = "Save File";
        }
        {
          key = "jk";
          mode = [ "i" ];
          action = "<esc>";
        }
        {
          key = "<leader>qq";
          mode = [ "n" ];
          action = "<cmd>qa<CR>";
        }
        {
          key = ">";
          mode = [ "x" ];
          action = ">gv";
        }
        {
          key = "<";
          mode = [ "x" ];
          action = "<gv";
        }
        {
          mode = [
            "i"
            "n"
            "s"
          ];
          key = "<esc>";
          action = lib.nixvim.utils.mkRaw ''
            function()
              vim.cmd("nohl")
              return "<esc>"
            end '';
          options = {
            expr = true;
            desc = "Escape and Clear hlsearch";
          };
        }

        # Add undo breakpoints

        {
          mode = [ "i" ];
          key = ",";
          action = ",<c-g>u";
        }
        {
          mode = [ "i" ];
          key = ".";
          action = ".<c-g>u";
        }
        {
          mode = [ "i" ];
          key = ";";
          action = ";<c-g>u";
        }

        # new file
        {
          key = "<leader>fn";
          action = "<cmd>enew<cr>";
          mode = [ "n" ];
          options = {
            silent = true;
            desc = "New File";
          };
        }

        {
          key = "+";
          action = "<c-a>";
          mode = [
            "n"
            "x"
          ];
          options.desc = "Increment";
        }
        {
          key = "-";
          action = "<c-x>";
          mode = [
            "n"
            "x"
          ];
          options.desc = "Decrement";
        }

        {
          key = "<leader>ui";
          action.__raw = "vim.show_pos";
          mode = [ "n" ];
          options.desc = "Inspect Pos";
        }
        {
          key = "<leader>uI";
          action.__raw = ''function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end'';
          mode = [ "n" ];
          options.desc = "Inspect Tree";
        }
        {
          key = "<leader>-";
          action = "<C-W>s";
          mode = [ "n" ];
          options = {
            desc = "Split Window Below";
            remap = true;
          };
        }
        {
          key = "<leader>|";
          action = "<C-W>v";
          mode = [ "n" ];
          options = {
            desc = "Split Window Right";
            remap = true;
          };
        }
        {
          key = "<leader>wd";
          action = "<C-W>c";
          mode = [ "n" ];
          options = {
            desc = "Delete Window";
            remap = true;
          };
        }

        {
          key = "<leader>fn";
          action = "<cmd>enew<cr>";
          mode = [ "n" ];
          options.desc = "New File";
        }

        {
          key = "gco";
          action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
          mode = [ "n" ];
          options.desc = "Add Comment Below";
        }
        {
          key = "gcO";
          action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
          mode = [ "n" ];
          options.desc = "Add Comment Above";
        }
      ];
      extraConfigLuaPost = ''
        Snacks.toggle({
          name = "Auto Format (Global)",
          get = function() return vim.g.autoformat == nil or vim.g.autoformat end,
          set = function(state)
            if state == nil then
              state = true
            end
            vim.g.autoformat = state
            vim.b.autoformat = nil
          end,
        })
        Snacks.toggle({
          name = "Auto Format (Buffer)",
          get = function() 
            buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf()
            local gaf = vim.g.autoformat
            local baf = vim.b[buf].autoformat

            -- If the buffer has a local value, use that
            if baf ~= nil then
              return baf
            end

            -- Otherwise use the global value if set, or true by default
            return gaf == nil or gaf
          end,
          set = function(state)
            if state == nil then
              state = true
            end
            vim.b.autoformat = state
          end,
        })
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
        Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.animate():map("<leader>ua")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.scroll():map("<leader>uS")
        Snacks.toggle.profiler():map("<leader>dpp")
        Snacks.toggle.profiler_highlights():map("<leader>dph")
        if vim.lsp.inlay_hint then
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end
        Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
        Snacks.toggle.zen():map("<leader>uz")
      '';
    };
}
