{ self, ... }:
{
  flake.nixosModules.nixvim =
    {
      inputs,
      ...
    }:
    {
      imports = [ inputs.nixvim.nixosModules.nixvim ];
      programs.nixvim = {
        enable = true;
        imports = [ self.nixosModules.nixvim-conf ];
      };
    };
}
