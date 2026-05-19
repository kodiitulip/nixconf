{
  flake.nixosModules.pear-desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.pear-desktop
      ];

      persistance.user-directories = [
        ".config/YouTube Music"
      ];
    };
}
