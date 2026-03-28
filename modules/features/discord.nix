{
  flake.nixosModules.discord =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vesktop
        # (discord.override {
        #   withOpenASAR = true;
        #   withVencord = true;
        # })
      ];
    };
}
