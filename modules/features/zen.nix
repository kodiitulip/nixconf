{ inputs, ... }:
{
  flake.nixosModules.zen =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.wrapFirefox
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
          {
            nativeMessagingHosts = [ pkgs.firefoxpwa ];
            extraPolicies = {
              DisableTelemetry = true;
              SearchEngines = {
                Default = "ddg";
                Add = [
                  {
                    Name = "NixOS packages";
                    URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                    IconURL = "https://wiki.nixos.org/favicon.ico";
                    Alias = "@np";
                  }
                  {
                    Name = "NixOS options";
                    URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                    IconURL = "https://wiki.nixos.org/favicon.ico";
                    Alias = "@no";
                  }
                  {
                    Name = "NixOS Wiki";
                    URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                    IconURL = "https://wiki.nixos.org/favicon.ico";
                    Alias = "@nw";
                  }
                  {
                    Name = "HomeManager options";
                    URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
                    IconURL = "https://home-manager-options.extranix.com/favicon.ico";
                    Alias = "@hm";
                  }
                  {
                    Name = "Noogle";
                    URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                    IconURL = "https://noogle.dev/favicon.ico";
                    Alias = "@ng";
                  }
                  {
                    Name = "Modrinth Mods";
                    URLTemplate = "https://modrinth.com/discover/mods?q={searchTerms}";
                    IconURL = "https://modrinth.com/favicon.ico";
                    Alias = "@mods";
                  }
                  {
                    Name = "Modrinth Shaders";
                    URLTemplate = "https://modrinth.com/discover/shaders?q={searchTerms}";
                    IconURL = "https://modrinth.com/favicon.ico";
                    Alias = "@shaders";
                  }
                  {
                    Name = "Modrinth Resourcepacks";
                    URLTemplate = "https://modrinth.com/discover/resourcepacks?q={searchTerms}";
                    IconURL = "https://modrinth.com/favicon.ico";
                    Alias = "@resources";
                  }
                  {
                    Name = "Modrinth Datapacks";
                    URLTemplate = "https://modrinth.com/discover/datapacks?q={searchTerms}";
                    IconURL = "https://modrinth.com/favicon.ico";
                    Alias = "@datas";
                  }
                ];
              };
            };
          }
        )
      ];
    };
}
