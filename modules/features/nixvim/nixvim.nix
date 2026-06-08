{ inputs, self, ... }:
{
  flake.nixosModules.nixvim = {
    imports = [ inputs.nixvim.nixosModules.nixvim ];
    programs.nixvim = {
      enable = true;
      nixpkgs.source = inputs.nixpkgs;
      imports = [ self.nixosModules.nixvim-conf ];
    };
  };
}
