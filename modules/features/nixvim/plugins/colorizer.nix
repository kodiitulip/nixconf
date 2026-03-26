{
  plugins.colorizer = {
    enable = true;
    settings = {
      filetypes = [
        "astro"
        "css"
        "heex"
        "html"
        "html-eex"
        "javascript"
        "javascriptreact"
        "rust"
        "svelte"
        "typescript"
        "typescriptreact"
        "vue"
      ];
      user_default_options = {
        css = true;
        tailwind = "both";
        tailwind_opts.update_name = true;
        sass = {
          enable = true;
          parsers = [ "css" ];
        };
        always_update = true;
      };
    };
  };
}
