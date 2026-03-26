{ inputs, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    {
      packages.nh = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.nh;
        env = {
          "NH_FLAKE" = "/home/${config.preferences.user.name}/nixconf";
        };
      };
    };
}
