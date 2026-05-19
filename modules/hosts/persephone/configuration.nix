{ self, inputs, ... }:
{
  flake.nixosConfigurations.persephone = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.persephone ];
  };

  flake.nixosModules.persephone =
    { pkgs, ... }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = with self.nixosModules; [
        base
        general
        desktop

        preservation

        discord
        pear-desktop

        art
        dev
        gaming
        powersave

        # disko
        inputs.disko.nixosModules.disko
        self.diskoConfigurations.persephone
      ];

      nix.settings.experimetal-features = [
        "nix-command"
        "flakes"
      ];

      preferences.user = {
        name = "kodie";
        profile-image = ./icon.png;
      };

      environment.systemPackages = with pkgs; [
        winetricks
        glib
        zerotierone
        # android-tools
        firefox
        vim
      ];

      persistance.cache.directories = [
        ".config/obs-studio"
      ];

      programs = {
        corectrl.enable = true;

        niri.enable = true;

        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            waveform
            obs-websocket
            obs-backgroundremoval
            obs-pipewire-audio-capture
            obs-vkcapture
            obs-tuna
          ];
          enableVirtualCamera = true;
        };

        appimage = {
          enable = true;
          binfmt = true;
        };
      };
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;

        loader.grub = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
        };

        supportedFilesystems.ntfs = true;

        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
        kernelModules = [
          "mt7921e"
          "coretemp"
          "cpuid"
          "v4l2loopback"
        ];

        binfmt.emulatedSystems = [ "aarch64-linux" ];
        plymouth = {
          enable = true;
          theme = "sakura";
          themePackages = with selfpkgs; [
            sakura-plymouth
          ];
        };
        consoleLogLevel = 3;
        initrd = {
          verbose = false;
          kernelModules = [ "amdgpu" ];
        };
        loader.timeout = 0;
      };

      networking = {
        hostName = "persephone";
        networkmanager.enable = true;
        hosts = {
          "192.168.0.105" = [ "hermes-pc" ];
          "172.24.145.167" = [ "julia-servers" ];
          "localhost:8080" = [ "dioxusdev" ];
          "localhost:3000" = [ "nextjsdev" ];
        };

        nftables.enable = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            80
            443
            3000
            8080
          ];
        };
      };

      hardware.cpu.amd.updateMicrocode = true;

      services = {
        hardware.openrgb.enable = true;
        flatpak.enable = true;
        udisks2.enable = true;
        printing.enable = true;

        zerotierone = {
          joinNetworks = [
            "bb720a5aaedee869" # julia's network
            "b9a18a606fecb004" # blossom-garden
          ];
        };
      };

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.enable = true;

      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [ "amdgpu" ];

      system.stateVersion = "26.05";
    };
}
