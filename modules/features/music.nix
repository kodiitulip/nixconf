{
  flake.nixosModules.music =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        pear-desktop
        spotify
        spicetify-cli
      ];

      persistance.user-directories = [
        ".config/YouTube Music"
      ];
    };
}
