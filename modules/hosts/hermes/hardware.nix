{
  flake.nixosModules.hermes =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        initrd.availableKernelModules = [
          "ahci"
          "xhci_pci"
          "uas"
          "sd_mod"
          "sdhci_pci"
        ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
