{ self, inputs, ... }:
{
  flake.nixosModules.home-manager =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${config.preferences.user.name}.imports = [ self.nixosModules.home-manager-conf ];
        backupFileExtension = "backup";
      };

    };

  flake.nixosModules.home-manager-conf =
    { config, lib, ... }:
    let
      username = config.preferences.user.name;
      userpfp = config.preferences.user.profile-image;
    in
    {
      programs.home-manager.enable = true;

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        file.".face.icon".source = lib.mkAfter (lib.optionals (userpfp != null) userpfp);

        # file.".local/share/godot/export_templates" = {
        #   source = "${pkgs.godot-export-templates-bin}/share/godot/export_templates";
        #   recursive = true;
        # };
      };
    };
}
