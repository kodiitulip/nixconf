{ self, inputs, ... }:
{
  flake.nixosConfigurations.hades = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hostHades ];
  };

  flake.nixosModules.hostHades =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.general
        self.nixosModules.desktop

        self.nixosModules.zen
        self.nixosModules.discord
        self.nixosModules.pear-desktop

        self.nixosModules.art
        self.nixosModules.dev
        self.nixosModules.gaming
        self.nixosModules.powersave
      ];

      nix.settings.experimetal-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = with pkgs; [
        winetricks
        glib
        zerotierone
        # android-tools
        firefox
        vim
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

        # kernelParams = ["quiet" "amd_pstate=guided" "processor.max_cstate=1"];
        kernelParams = [ "quiet" ];
        kernelModules = [
          "mt7921e"
          "coretemp"
          "cpuid"
          "v4l2loopback"
        ];

        binfmt.emulatedSystems = [ "aarch64-linux" ];
      };

      boot.plymouth.enable = true;

      networking = {
        hostName = "hades";
        networkmanager.enable = true;

        hosts."172.24.145.167" = [ "julia-servers" ];

        nftables.enable = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            80
            443
            3000
          ];
        };
      };

      hardware.cpu.amd.updateMicrocode = true;

      services = {
        hardware.openrgb.enable = true;
        flatpak.enable = true;
        udisks2.enable = true;
        printing.enable = true;
      };

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.enable = true;

      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [ "amdgpu" ];
      boot.initrd.kernelModules = [ "amdgpu" ];

      system.stateVersion = "25.05"; # WARN: DO NOT CHANGE! NO NEED TO!
    };
}
