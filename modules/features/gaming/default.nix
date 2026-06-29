{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.gaming =
    {
      pkgs,
      lib,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      # imports = [ inputs.vintagestory-nix.homeModules.default ];

      nixpkgs.overlays = [ inputs.vintagestory-nix.overlays.default ];

      hardware.graphics.enable = lib.mkDefault true;

      programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        steam = {
          package = pkgs.steam.override {
            extraProfile = ''
              unset TZ
              # Allows Monado/WiVRn to be used
              export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
            '';
          };
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
          extraPackages = with pkgs; [
            SDL2
            gamescope
          ];
          protontricks.enable = true;
        };
        # vs-launcher = {
        #   enable = true;
        #   settings.gameVersions = [
        #     pkgs.vintagestoryPackages.latest
        #     pkgs.vintagestoryPackages.v1-21-6
        #   ];
        # };
      };

      environment.systemPackages = with pkgs; [
        lutris
        steam-run
        steamtinkerlaunch
        (prismlauncher.override {
          additionalPrograms = [ vlc ];
          additionalLibs = [ vlc ];
          jdks = [
            jdk25
            jdk21
            jdk17
            temurin-bin-25
            temurin-bin-21
            temurin-bin-17
          ];
        })
        selfpkgs.hyprism
        easyeffects
        rose-pine-cursor
        protonplus
        hydralauncher
        mindustry
        vintagestoryPackages.rustique
        vintagestoryPackages.vs-launcher
        ryubing

        dxvk
        gamescope
        mangohud
        r2modman

        # NOTE: maybe when I buy lossless scaling?
        # lsfg-vk
        # lsfg-vk-ui
      ];

      services.zerotierone.enable = true;

      persistance.user.directories = [
        ".local/share/HyPrism"
        ".local/share/Hytale"
        ".local/share/hytale-launcher"
        ".config/HyPrism"

        ".local/share/Steam"
        ".local/share/bottles"
        ".local/share/PrismLauncher"
        ".config/r2modmanPlus-local"

        ".config/VSLInstallations"
        ".config/VSLBackups"
        ".config/VSLauncher"
        ".config/Ryujinx"
        ".config/unity3d"
        ".config/hydralauncher"

        ".local/share/Terraria"

        "Games"

        ".config/heroic"
      ];
    };
}
