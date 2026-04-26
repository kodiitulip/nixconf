{
  flake.nixosModules.nixvim-conf = _: {
    plugins.dial.enable = true;
  };
}
