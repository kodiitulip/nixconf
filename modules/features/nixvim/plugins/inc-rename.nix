{
  flake.nixosModules.nixvim-conf = _: {
    plugins.inc-rename.enable = true;
  };
}
