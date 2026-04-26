{
  flake.nixosModules.nixvim-conf = _: {
    colorschemes = {
      rose-pine = {
        enable = true;
        autoLoad = true;
      };
    };
  };
}
