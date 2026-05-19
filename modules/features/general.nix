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
        shell = pkgs.nushell;

        initialPassword = "${config.preferences.user.name}";
      };

      persistance.user-directories = [
        "Pictures"
        "Music"
        "Videos"
        "Documents"
        "Projects"

        ".ssh"
        ".local/share/zoxide"
        ".local/share/direnv"
        ".local/share/nvim"
      ];
    };
}
