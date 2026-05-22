{
  flake.nixosModules.art =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        krita
        aseprite

        pixieditor

        blockbench
        blender
      ];
      hardware.opentabletdriver.enable = true;
    };
}
