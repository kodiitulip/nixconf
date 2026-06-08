{ self, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
        imports = [ self.nixosModules.nixvim-conf ];
      };
    };

}
