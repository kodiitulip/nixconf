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

      environment.systemPackages = with pkgs; [ mcrcon ];

      services.vintagestory = {
        enable = false;
        package = pkgs.vintagestoryPackages.v1-21-6;
        openFirewall = true;
      };

      services.minecraft-servers = {
        enable = false;
        eula = true;
        openFirewall = true;

        servers.fossiled-steam = {
          enable = false;
          package = pkgs.neoforgeServers.neoforge-1_21_1;

          serverProperties = {
            server-port = 25565;
            online-mode = false;
            allow-flight = true;
            difficulty = "hard";
            motd = "Os Caba";
            rcon.port = 25575;
            enable-rcon = true;
            simulation-distance = 8;
            view-distance = 12;
          };

          symlinks =
            let
              modpack = pkgs.fetchPackwizModpack {
                url = "https://github.com/blossom-garden/fossilized-steam/raw/refs/tags/1.0.1/pack.toml";
                packHash = "";
              };
            in
            {
              "mods" = "${modpack}/mods";
              "datapacks" = "${modpack}/datapacks";
              "resourcepacks" = "${modpack}/resourcepacks";
              "config" = "${modpack}/config";
              "defaultoptions" = "${modpack}/defaultoptions";
              "server-icon.png" = "${modpack}/icon.png";
            };
        };
      };

    };
}
