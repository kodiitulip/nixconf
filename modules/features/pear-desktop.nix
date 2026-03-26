{
  flake.nixosModules.pear-desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.pear-desktop
      ];

      # persistance.cache.directories = [
      #   ".config/YouTube Music"
      # ];
    };
}
