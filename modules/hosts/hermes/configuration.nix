{ self, inputs, ... }:
{
  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hermes ];
  };

  flake.nixosModules.hermes =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        base
        general
        desktop

        impermanence

        nixvim
        gaming
        gaming-servers
        powersave

        # disko
        inputs.disko.nixosModules.disko
        self.diskoConfigurations.hermes
      ];

      nix.settings.experimetal-features = [
        "nix-command"
        "flakes"
      ];

      preferences.user = {
        name = "hermes";
        profile-image = ./icon.png;
      };

      environment.systemPackages = with pkgs; [
        winetricks
        glib
        zerotierone
        firefox
        vim
      ];

      persistance.cache.directories = [
        ".config/obs-studio"
      ];

      programs = {
        # corectrl.enable = true;
        niri.enable = true;
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
          theme = "pixels";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "pixels" ];
            })
          ];
        };
        consoleLogLevel = 3;
        initrd.verbose = false;
        loader.timeout = 0;
      };

      networking = {
        hostName = "hermes";
        networkmanager.enable = true;
        hosts = { };

        nftables.enable = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            80
            443
          ];
        };
      };

      services = {
        hardware.openrgb.enable = true;
        flatpak.enable = true;
        udisks2.enable = true;
        printing.enable = true;

        zerotierone = {
          joinNetworks = [
            "b9a18a606fecb004"
          ];
        };
      };

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.enable = true;

      hardware.graphics.enable = true;

      system.stateVersion = "25.05"; # WARN: DO NOT CHANGE! NO NEED TO!
    };
}
