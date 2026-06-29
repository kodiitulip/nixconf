{ self, ... }:
{
  flake.nixosModules.gamedev =
    { pkgs, config, ... }:
    {
      imports = [
        self.nixosModules.nixvim
        self.nixosModules.art
      ];
      environment.systemPackages = with pkgs; [
        godot
        material-maker
      ];

      hjem.users.${config.preferences.user.name}.files.".local/share/godot/export_templates".source =
        "${pkgs.godot-export-templates-bin}/share/godot/export_templates";
    };
}
