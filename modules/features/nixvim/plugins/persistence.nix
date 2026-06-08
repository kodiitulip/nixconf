{
  flake.nixosModules.nixvim-conf = {
    plugins.persistence = {
      enable = true;
      settings = { };
    };

    keymaps = [
      {
        key = "<leader>q";
        action = "";
        options.desc = "Persistence";
      }
      {
        key = "<leader>qs";
        action.__raw = "function() require('persistence').load() end ";
        options.desc = "Load session for current directory";
      }
      {
        key = "<leader>qS";
        action.__raw = "function() require('persistence').select() end ";
        options.desc = "Select session to load";
      }
      {
        key = "<leader>ql";
        action.__raw = "function() require('persistence').load({ last = true }) end ";
        options.desc = "Load last session";
      }
      {
        key = "<leader>qd";
        action.__raw = "function() require('persistence').stop() end ";
        options.desc = "Stop persistence (don't save session)";
      }
    ];
  };
}
