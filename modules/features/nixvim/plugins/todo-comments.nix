{
  flake.nixosModules.nixvim-conf = {
    plugins.todo-comments.enable = true;
    keymaps = [
      {
        key = "]t";
        action.__raw = ''
          function()
            require("todo-comments").jump_next()
          end
        '';
        mode = [ "n" ];
        options.desc = "Next todo comment";
      }
      {
        key = "[t";
        action.__raw = ''
          function()
            require("todo-comments").jump_prev()
          end
        '';
        mode = [ "n" ];
        options.desc = "Previous todo comment";
      }
      {
        key = "]T";
        action.__raw = ''
          function()
            require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
          end
        '';
        mode = [ "n" ];
        options.desc = "Next error/warning todo comment";
      }
      {
        key = "[T";
        action.__raw = ''
          function()
            require("todo-comments").jump_prev({ keywords = { "ERROR", "WARNING" } })
          end
        '';
        mode = [ "n" ];
        options.desc = "Previous error/warning todo comment";
      }
    ];
  };
}
