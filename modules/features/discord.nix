{
  flake.nixosModules.discord =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vesktop
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
      ];

      persistance.user.directories = [
        ".config/discord"
        ".config/vesktop"
        ".config/Vencord"
      ];
    };
}
