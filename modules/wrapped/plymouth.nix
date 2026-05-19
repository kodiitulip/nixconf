{
  perSystem =
    { pkgs, ... }:
    {
      packages.sakura-plymouth = pkgs.stdenv.mkDerivation {
        pname = "sakura-plymouth";
        version = "1.0.0";
        src = ../plymouth-themes/sakura;

        sourceRoot = ".";

        installPhase = ''
          mkdir -pv $out/share/plymouth/themes
          ls
          mv sakura $out/share/plymouth/themes/sakura
          find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
        '';
      };
    };
}
