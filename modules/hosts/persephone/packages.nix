{
  flake.nixosModules.persephone =
    { pkgs, config, ... }:
    {
      hjem.users.${config.preferences.user.name}.packages = with pkgs; [
        yt-dlp
        mpv
        vlc
        protonmail-desktop
        kdePackages.kate
      ];
    };
}
