{ inputs, ... }:
{
  flake.nixosModules.hjem =
    { config, ... }:
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

          files.".face.icon".source = profile;

          clobberByDefault = true;
        };
      };
    };
}
