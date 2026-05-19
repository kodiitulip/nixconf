{ inputs, self, ... }:
{
  flake.nixosModules.nixvim = {
    imports = [ inputs.nixvim.nixosModules.nixvim ];
    programs.nixvim = {
      enable = true;
      imports = [ self.nixosModules.nixvim-conf ];
    };
  };
}
