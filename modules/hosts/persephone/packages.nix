{
  flake.nixosModules.persephone =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        youtube-tui
        yt-dlp
        mpv
        vlc
        protonmail-desktop
      ];

      files.".local/share/godot/export_templates" = {
        source = "${pkgs.godot-export-templates-bin}/share/godot/export_templates";
        recursive = true;
      };
    };
}
