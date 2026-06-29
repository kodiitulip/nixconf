{ self, inputs, ... }:
{
  flake.nixosModules.nix =
    { pkgs, config, ... }:
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
          nix-direnv.enable = true;
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
      };

      nixpkgs.config.allowUnfree = true;
      hjem.users.${config.preferences.user.name} = {
        xdg.config.files."direnv/direnv.toml".source = (pkgs.formats.toml { }).generate "direnv.toml" {
          global = {
            warn_timeout = "0s";
            hide_env_diff = true;
          };
        };
        rum.programs.nix-your-shell = {
          integrations.nushell.enable = true;
          enable = true;
        };
      };

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 3d";
        };
        flake = "/home/${config.preferences.user.name}/nixconf";
      };

      environment.systemPackages = with pkgs; [
        # Nix tooling
        nil
        nixd
        statix
        alejandra
        manix
        nix-inspect
        nh
      ];
    };
}
