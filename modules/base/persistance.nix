{
  flake.nixosModules.base =
    { lib, config, ... }:
    {
      options.persistance = {
        enable = lib.mkEnableOption "enable persistance";

        user = {
          name = lib.mkOption {
            default = config.preferences.user.name;
            description = ''
              Main user
            '';
          };

          directories = lib.mkOption {
            default = [ ];
            description = ''
              user directories to persist
            '';
          };

          files = lib.mkOption {
            default = [ ];
            description = ''
              user files to persist
            '';
          };
        };

        directories = lib.mkOption {
          default = [ ];
          description = ''
            directories to persist
          '';
        };

        files = lib.mkOption {
          default = [ ];
          description = ''
            files to persist
          '';
        };
      };
    };
}
