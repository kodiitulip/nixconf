{
  flake.nixosModules.nixvim-conf = _: {
    plugins.rustaceanvim.enable = false;
  };
}
