{
  plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = [ "statix" ];
      javascript = [ "eslint_d" ];
      javascriptreact = [ "eslint_d" ];
      typescript = [ "eslint_d" ];
      typescriptreact = [ "eslint_d" ];
      markdown = [ "markdownlint-cli2" ];
      gdscript = [ "gdlint" ];
      rust = [ "clippy" ];
    };
  };

  autoCmd = [
    {
      event = [
        "BufRead"
        "BufWritePost"
        "InsertLeave"
        "TextChanged"
      ];
      callback.__raw = "function() require('lint').try_lint() end";
      desc = "Lint when TextChanged or InsertLeave";
    }
  ];
}
