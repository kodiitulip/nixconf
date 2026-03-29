{
  lib,
  pkgs,
  ...
}:
{
  extraConfigLuaPre = ''
    local slow_format_filetypes = {}

    vim.api.nvim_create_user_command("FormatDisable", function(args)
       if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
    vim.api.nvim_create_user_command("FormatToggle", function(args)
      if args.bang then
        -- Toggle formatting for current buffer
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      else
        -- Toggle formatting globally
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      end
    end, {
      desc = "Toggle autoformat-on-save",
      bang = true,
    })
  '';
  plugins.conform-nvim = {
    enable = true;
    settings = {
      log_level = "debug";
      default_format_opts.lsp_format = "fallback";
      format_on_save.__raw = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end

          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_fallback = true }, on_format
         end
      '';

      format_after_save.__raw = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end

          return { lsp_fallback = true }
        end
      '';
      notify_on_error = true;
      formatters_by_ft = {
        html = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        css = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        javascriptreact = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        typescriptreact = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        typescript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        python = [
          "black"
          "isort"
        ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        markdown = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        nushell = [ "nufmt" ];
        yaml = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        json = [ "jq" ];
        java = [ "astyle" ];
        gdscript = [ "gdscript-formatter" ];
        rust = [
          "rustfmt"
          "dioxus-fmt"
        ];
        "_" = [ "trim_whitespace" ];
      };

      formatters = {
        nufmt.command = lib.getExe pkgs.nufmt;
        black.command = lib.getExe pkgs.black;
        isort.command = lib.getExe pkgs.isort;
        nixfmt.command = lib.getExe pkgs.nixfmt;
        alejandra.command = lib.getExe pkgs.alejandra;
        jq.command = lib.getExe pkgs.jq;
        prettierd.command = lib.getExe pkgs.prettierd;
        stylua.command = lib.getExe pkgs.stylua;
        shellcheck.command = lib.getExe pkgs.shellcheck;
        shfmt.command = lib.getExe pkgs.shfmt;
        shellharden.command = lib.getExe pkgs.shellharden;
        dioxus-fmt = {
          command = "dx";
          args = [
            "fmt"
            "-s"
            "-f"
            "$FILENAME"
          ];
          stdin = false;
          tmpfile_format = ".conform.$RANDOM.$FILENAME";
          condition.__raw = ''
            function(self, ctx)
              local lines = vim.fn.readfile(ctx)
              if #lines == 0 then return false end
              local content = table.concat(lines, "\n")
              return content:find(substring, 1, true) ~= nil
            end
          '';
        };
        injected.options.ignore_errors = true;
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>cf";
      action.__raw = "function() require('conform').format() end";
      options.desc = "Format";
    }
    {
      key = "<leader>cF";
      action.__raw = ''
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end
      '';
      mode = [
        "n"
        "x"
      ];
      options.desc = "Format Injected Langs";
    }
  ];
}
