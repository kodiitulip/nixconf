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
            pkgs.vintagestoryPackages.v1-21-6
          ];
        };
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
        selfpkgs.mrpack-install

        # NOTE: maybe when I buy lossless scaling?
        # lsfg-vk
        # lsfg-vk-ui
      ];

      services.zerotierone.enable = true;

      persistance.user-directories = [
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

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        mrpack-install = pkgs.mrpack-install.overrideAttrs (old: rec {
          version = "0.21.0-beta";
          src = pkgs.fetchFromGitHub {
            owner = "nothub";
            repo = "mrpack-install";
            tag = "v${version}";
            hash = "sha256-QSgq9VgiEg2aZLgMhzhFE2IpSVcYdmmRV9CJWkWPkg4=";
          };
          vendorHash = "sha256-ZbQICz2z2+SPY1z9dS5AXJh18+522PfT/wPg5GhmNZQ=";
          checkFlags =
            let
              skippedTests = [
                # Skip tests that require network access
                "TestFetchMetadata"
                "TestClient_VersionFromHash"
                "TestClient_GetDependencies"
                "TestClient_GetProjectVersions_Count"
                "TestClient_GetVersion"
                "TestClient_CheckProjectValidity_Slug"
                "Test_GetProject_404"
                "TestClient_GetProjects_Count"
                "TestClient_GetProjectVersions_Filter_NoResults"
                "Test_GetProject_Success"
                "TestClient_CheckProjectValidity_Id"
                "TestClient_GetLatestGameVersion"
                "TestClient_GetProjectVersions_Filter_Results"
                "TestClient_GetProjects_Slug"
                "TestClient_GetVersions"
                "TestGetPlayerUuid"
                "TestClient_VersionFromMrpackFile"
              ];
            in
            [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
          postInstall = "";
        });

        hyprism =
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
    };
}
