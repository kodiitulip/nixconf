{ self, ... }:
{
  flake.nixosModules.general =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.hjem
        self.nixosModules.gtk
        self.nixosModules.git
        self.nixosModules.nix
        self.nixosModules.nushell
        self.nixosModules.starship
      ];

      users.users.${config.preferences.user.name} = {
        isNormalUser = true;
        description = "${config.preferences.user.name}'s account";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        shell = self.packages.${pkgs.system}.environment;

        initialPassword = "${config.preferences.user.name}";
      };

      persistance.data.directories = [
        "nixconf"

        "Pictures"
        "Music"
        "Videos"
        "Documents"
        "Projects"

        ".ssh"
      ];

      persistance.cache.directories = [
        ".local/share/zoxide"
        ".local/share/direnv"
        ".local/share/nvim"
        ".config/nvim"
      ];
    };
}
