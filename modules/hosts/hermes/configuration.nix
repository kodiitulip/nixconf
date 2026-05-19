{ self, inputs, ... }:
{
  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hermes ];
  };

  flake.nixosModules.hermes =
    { pkgs, config, ... }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = with self.nixosModules; [
        base
        general
        desktop

        preservation

        nixvim
        # gaming
        gaming-servers
        powersave

        # disko
        inputs.disko.nixosModules.disko
        inputs.disko.flakeModules.disko
        self.diskoConfigurations.hermes
      ];

      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
        autoLogin = {
          enable = true;
          user = config.preferences.user.name;
        };
      };

      preferences.user = {
        name = "hermes";
        profile-image = ./icon.png;
      };

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlsbUta5cO8PicTkHK/QsGstrJkF0m3mtQbiVwbHWRy"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5gmq70r9IzcBbS5p9GFQwFAvAhTAeWBkPrLklNPsen"
      ];

      environment.systemPackages = with pkgs; [
        winetricks
        glib
        zerotierone
        firefox
        vim
      ];

      persistance = {
        enable = true;
        user = config.preferences.user.name;
      };

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
          theme = "sakura";
          themePackages = with selfpkgs; [
            sakura-plymouth
          ];
        };
        consoleLogLevel = 3;
        initrd.verbose = false;
        loader.timeout = 0;
      };

      networking = {
        hostName = "hermes";
        networkmanager.enable = true;
        hosts = {
          "192.168.0.104" = [ "persephone-pc" ];
        };

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
            "b9a18a606fecb004" # blossom-garden
          ];
        };
      };

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.enable = true;

      hardware.graphics.enable = true;

      system.stateVersion = "26.05";
    };
}
