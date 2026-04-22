{
  flake.nixosModules.persephone =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yt-dlp
        mpv
        vlc
        protonmail-desktop
      ];
    };
}
