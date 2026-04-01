{ self, ... }:
{
  flake.nixosModules.dev =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.nixvim
      ];
      environment.systemPackages = with pkgs; [
        kdePackages.kate
        godot
        penpot-desktop
      ];

      files.".local/share/godot/export_templates" = {
        source = "${pkgs.godot-export-templates-bin}/share/godot/export_templates";
        recursive = true;
      };
    };
}
