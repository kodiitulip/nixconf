{ inputs, ... }:
{
  flake.nixosModules.hjem =
    { config, lib, ... }:
    let
      user = config.preferences.user.name;
      profile = config.preferences.user.profile-image;
    in
    {
      imports = [
        inputs.hjem.nixosModules.default
      ];

      config = {
        hjem = {
          extraModules = [
            inputs.hjem-rum.hjemModules.default
          ];

          users."${user}" = {
            enable = true;
            directory = "/home/${user}";
            user = "${user}";
          };

          files.".face.icon".source = lib.mkAfter (lib.optionals (profile != null) profile);

          clobberByDefault = true;
        };
      };
    };
}
