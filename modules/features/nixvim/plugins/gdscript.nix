{
  flake.nixosModules.nixvim-conf = _: {
    plugins.gdscript-extended-lsp = {
      enable = true;
      settings = {
        picker = "snacks";
        view_type = "floating";
        doc_file_extension = ".md";
      };
    };
  };
}
