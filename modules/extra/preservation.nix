{ inputs, ... }:
{
  flake.nixosModules.preservation =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.persistance;
    in
    {
      imports = [
        inputs.preservation.nixosModules.default
      ];

      config = lib.mkIf cfg.enable {
        boot.tmp.cleanOnBoot = true;
        preservation = {
          enable = true;

          preserveAt."/persistent" = {
            directories = [
              "/var/lib/systemd/timers"
              "/var/lib/systemd/coredump"
              "/var/log"
              "/var/lib/bluetooth"
              "/var/lib/zerotier-one"

              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }

              "/etc/nixos"
              "/etc/NetworkManager/system-connections"
              "/tmp"
            ]
            ++ cfg.directories;

            files = [
              {
                file = "/etc/machine-id";
                inInitrd = true;
              }
            ]
            ++ cfg.files;

            users.${cfg.user.name} = {
              files = cfg.user.files;
              directories = [ "nixconf" ] ++ cfg.user.directories;
            };
          };

        };
      };
    };
}
