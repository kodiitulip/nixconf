{
  flake.nixosModules.art =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        krita
        aseprite
        blockbench
        blender
      ];

    };
}
