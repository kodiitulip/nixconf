{
  flake.diskoConfigurations.persephone =
    { lib, config, ... }:
    {
      fileSystems."/nix".neededForBoot = true;
      disko.devices = {
        disk.main = {
          device = lib.mkDefault "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              swap = {
                size = "8G";
                content = {
                  type = "swap";
                  resumeDevice = true;
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];

                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                    };

                    "/nix" = {
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                      mountpoint = "/nix";
                    };

                    "/home" = {
                      mountOptions = [
                        "compress=zstd"
                      ];
                      mountpoint = "/home";
                    };

                    "/home/${config.preferences.user.name}" = { };
                  };
                };
              };
            };
          };
        };
      };
    };
}
