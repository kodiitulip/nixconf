{
  plugins = {
    ts-autotag.enable = true;
    nvim-autopairs = {
      enable = true;
      settings = {
        disable_filetype = [
          "TelescopePrompt"
          "vim"
          "snacks_picker_list"
        ];
      };
    };
  };
}
