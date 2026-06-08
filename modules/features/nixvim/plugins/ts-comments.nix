{
  flake.nixosModules.nixvim-conf = {
    plugins.ts-comments = {
      enable = true;

      settings.lang = {
        html = "<!-- %s -->";
        ini = "; %s";
        javascript = {
          __unkeyed-1 = "// %s";
          __unkeyed-2 = "/* %s */";
          call_expression = "// %s";
          jsx_attribute = "// %s";
          jsx_element = "{/* %s */}";
          jsx_fragment = "{/* %s */}";
          spread_element = "// %s";
          statement_block = "// %s";
        };
        rust = [
          "// %s"
          "/* %s */"
        ];
        tsx = {
          __unkeyed-1 = "// %s";
          __unkeyed-2 = "/* %s */";
          call_expression = "// %s";
          jsx_attribute = "// %s";
          jsx_element = "{/* %s */}";
          jsx_fragment = "{/* %s */}";
          spread_element = "// %s";
          statement_block = "// %s";
        };
        typescript = [
          "// %s"
          "/* %s */"
        ];
      };
    };
  };
}
