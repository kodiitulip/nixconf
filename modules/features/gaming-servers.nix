{ inputs, ... }:
{
  flake.nixosModules.gaming-servers =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers
        inputs.vintagestory-nix.nixosModules.default
      ];

      nixpkgs.overlays = [
        inputs.nix-minecraft.overlay
        inputs.vintagestory-nix.overlays.default
      ];

      environment.systemPackages = with pkgs; [ tmux ];
      services = {
        zerotierone.enable = true;

        vintagestory = {
          enable = false;
          package = pkgs.vintagestoryPackages.v1-21-6;
          openFirewall = true;
        };

        minecraft-servers =
          let
            thems-the-rules = pkgs.fetchPackwizModpack {
              url = "https://github.com/blossom-garden/thems-the-rules/raw/refs/tags/1.0.0/pack.toml";
              packHash = "";
            };
          in
          {
            enable = false;
            eula = true;
            openFirewall = true;
            dataDir = "/srv/minecraft-servers";

            servers = {
              ttrs-vini = {
                enable = false;
                autostart = false;
                package = pkgs.neoforge-server-1_21_1;

                serverProperties = {
                  server-port = 25565;
                  online-mode = false;
                  allow-flight = true;
                  difficulty = "hard";
                  motd = "Os Caba";
                  simulation-distance = 8;
                  view-distance = 10;
                };

                symlinks = {
                  "mods" = "${thems-the-rules}/mods";
                  "datapacks" = "${thems-the-rules}/datapacks";
                  "resourcepacks" = "${thems-the-rules}/resourcepacks";
                  "server-icon.png" = "${thems-the-rules}/server-icon.png";
                };
                files = {
                  "config" = "${thems-the-rules}/config";
                };
              };

              ttrs-julia = {
                enable = false;
                autoStart = false;
                package = pkgs.neoforge-server-1_21_1;

                serverProperties = {
                  server-port = 25566;
                  online-mode = true;
                  allow-flight = true;
                  difficulty = "hard";
                  motd = "Judie";
                  simulation-distance = 8;
                  view-distance = 10;
                };

                symlinks = {
                  "mods" = "${thems-the-rules}/mods";
                  "datapacks" = "${thems-the-rules}/datapacks";
                  "resourcepacks" = "${thems-the-rules}/resourcepacks";
                  "server-icon.png" = "${thems-the-rules}/server-icon.png";
                };
                files = {
                  "config" = "${thems-the-rules}/config";
                };
              };
            };
          };
      };

      persistance.directories = [ "/srv/minecraft-servers" ];

    };
}
