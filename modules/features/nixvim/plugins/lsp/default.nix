{
  flake.nixosModules.nixvim-conf =
    { pkgs, ... }:
    {
      extraPackages = with pkgs; [
        nil
        nixd
      ];
      lsp = {
        inlayHints.enable = true;
        keymaps = [
          {
            key = "gd";
            action.__raw = "function() Snacks.picker.lsp_definitions() end";
            options.desc = "Goto Definition";
          }
          {
            key = "gr";
            action.__raw = "function() Snacks.picker.lsp_references() end";
            options = {
              desc = "References";
              nowait = true;
            };
          }
          {
            key = "gI";
            action.__raw = "function() Snacks.picker.lsp_implementations() end";
            options.desc = "Goto Implementation";
          }
          {
            key = "gy";
            action.__raw = "function() Snacks.picker.lsp_type_definitions() end";
            options.desc = "Goto T[y]pe Definition";
            # lspBufAction = "type_definition";
          }
          {
            key = "gD";
            # action.__raw = "vim.lsp.buf.declaration";
            options.desc = "Goto Declaration";
            lspBufAction = "declaration";
          }
          {
            key = "K";
            # action = "<cmd>Lspsaga hover_doc<cr>";
            lspBufAction = "hover";
            options = {
              desc = "Hover";
              silent = true;
            };
          }
          {
            key = "gK";
            # action.__raw = "function() return vim.lsp.buf.signature_help() end";
            options.desc = "Signature Help";
            lspBufAction = "signature_help";
          }
          {
            key = "<c-k>";
            # action.__raw = "function() return vim.lsp.buf.signature_help() end";
            mode = [ "i" ];
            options.desc = "Signature Help";
            lspBufAction = "signature_help";
          }
          {
            key = "<leader>ca";
            options.desc = "Code Action";
            mode = [
              "n"
              "x"
            ];
            lspBufAction = "code_action";
          }
          {
            key = "<leader>cc";
            action.__raw = "vim.lsp.codelens.run";
            options.desc = "Run Codelens";
            mode = [
              "n"
              "x"
            ];
          }
          {
            key = "<leader>cC";
            action.__raw = "vim.lsp.codelens.refresh";
            options.desc = "Refresh & Display Codelens";
            mode = [ "n" ];
          }
          {
            key = "<leader>cR";
            action.__raw = "function() Snacks.rename.rename_file() end";
            options.desc = "Rename File";
            mode = [ "n" ];
          }
          {
            key = "<leader>cr";
            action.__raw = ''
              function() 
                local inc = require('inc_rename')
                return ":" .. inc.config.cmd_name .. " " .. vim.fn.expand("<cword>")
              end
            '';
            options = {
              expr = true;
              desc = "Rename";
            };
          }
          {
            key = "gai";
            action.__raw = "function() Snacks.picker.lsp_incoming_calls() end";
            options.desc = "Incoming Calls";
          }
          {
            key = "gao";
            action.__raw = "function() Snacks.picker.lsp_outgoing_calls() end";
            options.desc = "Outgoing Calls";
          }
          {
            key = "<leader>cd";
            options = {
              desc = "Show diagnostics under the cursor";
              silent = true;
            };
            # action = "<cmd>Lspsaga show_cursor_diagnostics<cr>";
            action.__raw = "vim.diagnostic.open_float";

          }
          {
            key = "<leader>sd";
            options.desc = "Search diagnostics";
            action.__raw = "function() Snacks.picker.diagnostics() end";
          }
          {
            key = "]]";
            action.__raw = "function() Snacks.words.jump(vim.v.count1) end";
            options.desc = "Next Reference";
          }
          {
            key = "[[";
            action.__raw = "function() Snacks.words.jump(-vim.v.count1) end";
            options.desc = "Prev Reference";
          }
          {
            key = "<a-n>";
            action.__raw = "function() Snacks.words.jump(vim.v.count1, true) end";
            options.desc = "Next Reference";
          }
          {
            key = "<a-p>";
            action.__raw = "function() Snacks.words.jump(-vim.v.count1, true) end";
            options.desc = "Prev Reference";
          }

          {
            key = "<leader>ss";
            action.__raw = "function() Snacks.picker.lsp_symbols() end";
            options.desc = "LSP Symbols";
          }
          {
            key = "<leader>sS";
            action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
            options.desc = "LSP Workspace Symbols";
          }
        ];

        servers = {
          "*" = {
            enable = true;
            config = {
              capabilities = {
                workspace.fileOperations = {
                  didRename = true;
                  willRename = true;
                };
                textDocument.semanticTokens.multilineTokenSupport = true;
              };
              root_markers = [ ".git" ];
            };
          };
          statix.enable = true;
          spyglassmc_language_server = {
            enable = true;
            package = null;
            config = {
              cmd = [
                "spyglassmc-language-server"
                "--stdio"
              ];
              filetypes = [
                "mcfunction"
                "json.mcdatapack"
                "mcdoc"
                "json.mcmeta"
              ];
              root_markers = [ "pack.mcmeta" ];
            };
          };
          gdscript = {
            enable = true;
            config = {
              cmd.__raw = "vim.lsp.rpc.connect('127.0.0.1', tonumber(os.getenv 'GDScript_Port' or '6005'))";
              on_attach.__raw = ''
                function(client, bufnr)
                  local server_pipe = vim.fn.getcwd() .. '/godothost'
                  if not vim.uv.fs_stat(server_pipe) then
                    vim.fn.serverstart(server_pipe)
                  end
                end
              '';
            };
          };
          superhtml.enable = true;
          sqls.enable = true;
          nushell.enable = true;
          lua_ls.enable = true;
          nil_ls = {
            enable = true;
            package = pkgs.nil;
          };
          nixd = {
            enable = true;
            package = pkgs.nixd;
          };
          ts_ls.enable = true;
          emmet_language_server.enable = true;
          tailwindcss = {
            enable = true;
            config = {
              filetypes = [
                "aspnetcorerazor"
                "astro"
                "astro-markdown"
                "blade"
                "clojure"
                "django-html"
                "htmldjango"
                "edge"
                "eelixir"
                "elixir"
                "ejs"
                "erb"
                "eruby"
                "gohtml"
                "gohtmltmpl"
                "haml"
                "handlebars"
                "hbs"
                "html"
                "htmlangular"
                "html-eex"
                "heex"
                "jade"
                "leaf"
                "liquid"
                "markdown"
                "mdx"
                "mustache"
                "njk"
                "nunjucks"
                "php"
                "razor"
                "slim"
                "twig"
                "css"
                "less"
                "postcss"
                "sass"
                "scss"
                "stylus"
                "sugarss"
                "javascript"
                "javascriptreact"
                "reason"
                "rescript"
                "typescript"
                "typescriptreact"
                "vue"
                "svelte"
                "templ"
                "rust"
              ];
              settings = {
                tailwindCSS = {
                  includeLanguages."rust" = "html";
                  experimental.classRegex = [ "class\\s*:\\s*\"([^\"]*)" ];
                  classAttributes = [
                    "class"
                    "className"
                    "class:list"
                    "classList"
                    "ngClass"
                    "class\\s*:\\s*\"([^\"]*)"
                  ];
                };
              };
            };
          };
          rust_analyzer.enable = true;
          marksman.enable = true;
          jdtls.enable = true;
          pyright.enable = true;
          jsonls = {
            enable = true;
            config.filetypes = [
              "json"
              "jsonc"
              "json.mcmeta"
              "json.mcdatapack"
            ];
          };
          helm_ls.enable = true;
          yamlls = {
            enable = true;
            config = {
              settings = {
                yaml = {
                  schemas = {
                    kubernetes = "'*.yaml";
                    "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                    "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                    "http://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                    "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                    "http://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                    "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                    "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                    "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                      "*docker-compose*.{yml,yaml}";
                    "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                      "*flow*.{yml,yaml}";
                  };
                };
              };
            };
          };
        };
      };
      plugins = {
        jdtls.enable = true;
        helm.enable = true;
        lspconfig.enable = true;
      };

      keymaps = [
      ];

      extraConfigLua = ''
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)

        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function(buffer)
          if vim.opt.foldmethod == "expr" then
            vim.opt.foldexpr = vim.treesitter.foldexpr()
          end
        end)
      '';
    };
}
