{ self, inputs, ... }:
{
  flake.nixosModules.gaming =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.vintagestory-nix.homeModules.default ];

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
        vs-launcher = {
          enable = true;
          settings.gameVersions = [
            pkgs.vintagestoryPackages.latest
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        lutris
        steam-run
        heroic
        steamtinkerlaunch
        (prismlauncher.override {
          additionalPrograms = [
            vlc
            temurin-bin
          ];
          additionalLibs = [
            vlc
            temurin-bin
          ];
        })
        self.packages.${pkgs.system}.hyprism
        easyeffects
        rose-pine-cursor
        protonup-qt
        hydralauncher
        mindustry
        vintagestoryPackages.rustique
        vintagestoryPackages.vs-launcher

        dxvk
        gamescope
        mangohud
        r2modman

        # NOTE: maybe when I buy lossless scaling?
        # lsfg-vk
        # lsfg-vk-ui
      ];

      services.zerotierone.enable = true;

      # persistance.cache.directories = [
      #   ".local/share/Hytale"
      #   ".local/share/hytale-launcher"
      #
      #   ".local/share/Steam"
      #   ".local/share/bottles"
      #   ".local/share/PrismLauncher"
      #   ".config/r2modmanPlus-local"
      #
      #   ".local/share/Terraria"
      #
      #   "Games"
      #
      #   ".config/heroic"
      # ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.hyprism =
        let
          pname = "hyprism";
          version = "3.0.1";

          src = pkgs.fetchurl {
            url = "https://github.com/HyPrismTeam/HyPrism/releases/download/v${version}/HyPrism-linux-x86_64-${version}.AppImage";
            hash = "sha256-vb93cI9ABNJqrhe09JB0oTz5dCe9cPfPj/U3Ps/Ud+s=";
          };

          appimageContents = pkgs.appimageTools.extractType2 {
            inherit pname version src;
          };
        in
        pkgs.appimageTools.wrapType2 {
          inherit pname version src;

          extraPkgs =
            pkgs: with pkgs; [
              icu
              openssl
              zlib
              libunwind
              libuuid
              stdenv.cc.cc
              libGL
              libx11
              libxcursor
              libxrandr
              libxext
              libxi
              libxkbcommon
            ];

          extraWrapperArgs = [
            "--add-flags"
            "--ozone-platform-hint=auto"
            "--add-flags"
            "--enable-features=WaylandWindowDecorations"
          ];

          extraInstallCommands = ''
            mkdir -pv $out/share/applications $out/share/icons/hicolor/256x256/apps

            install -m 444 ${appimageContents}/HyPrism.desktop \
              $out/share/applications/${pname}.desktop
            install -m 444 ${appimageContents}/HyPrism.png \
              $out/share/icons/hicolor/256x256/apps/${pname}.png

            substituteInPlace $out/share/applications/${pname}.desktop \
              --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
              --replace-fail 'Icon=HyPrism' 'Icon=${pname}'
          '';

          meta = {
            description = "Hytale launcher with mod management";
            homepage = "https://github.com/HyPrismTeam/HyPrism";
            platforms = [ "x86_64-linux" ];
          };
        };
    };
}
