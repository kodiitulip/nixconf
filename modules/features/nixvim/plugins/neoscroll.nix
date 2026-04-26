{
  flake.nixosModules.nixvim-conf = _: {
    plugins.neoscroll.enable = true;
  };
}
