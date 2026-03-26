{
  flake.nixosModules.base =
    { lib, ... }:
    {
      options.preferences = {
        user = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "kodie";
          };
          profile-image = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
          };
        };
      };
    };
}
