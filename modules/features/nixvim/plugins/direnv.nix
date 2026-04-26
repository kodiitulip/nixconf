{
  flake.nixosModules.nixvim-conf = _: {
    plugins.direnv.enable = true;
  };
}
