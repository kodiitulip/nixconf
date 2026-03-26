{ self, inputs, ... }:
{
  flake.nixosModules.nix =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index
      ];
      programs = {
        nix-index-database.comma.enable = true;

        direnv = {
          enable = true;
          silent = false;
          loadInNixShell = true;
          direnvrcExtra = "";
          nix-direnv = {
            enable = true;
          };
        };
        nix-ld.enable = true;
      };

      nix = {
        settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        optimise.automatic = true;

        gc = {
          automatic = true;
          dates = "weekly";
          options = "-d";
        };
      };
      nixpkgs.config.allowUnfree = true;
      rum.programs.nix-your-shell = {
        integrations.nushell.enable = true;
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        # Nix tooling
        nil
        nixd
        statix
        alejandra
        manix
        nix-inspect
        self.packages.${pkgs.system}.nh
        self.packages.${pkgs.system}.qalc
      ];
    };
}
