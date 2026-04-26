{
  flake.nixosModules.nixvim-conf = _: {
    plugins.yanky.enable = true;
  };
}
