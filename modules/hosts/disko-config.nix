{ lib, ... }:
{
  options.flake.diskoConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = "Instantiated Disko configurations. Used by `disko` and `disko-install`.";
  };
}
