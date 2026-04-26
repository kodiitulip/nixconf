{ self, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    let
      selfpkgs = self.packages.${pkgs.system};
    in
    {
      imports = [
        self.nixosModules.gtk
        self.nixosModules.pipewire
      ];

      programs.niri = {
        enable = true;
        package = selfpkgs.niri;
      };

      preferences.autostart = [ selfpkgs.noctalia-shell ];

      environment.systemPackages =
        (with selfpkgs; [
          zen
          kitty
        ])
        ++ (with pkgs; [
          kdePackages.dolphin
        ]);

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        ubuntu-sans
        cm_unicode
        corefonts
        unifont
      ];

      fonts.fontconfig.defaultFonts = {
        serif = [ "Ubuntu Sans" ];
        sansSerif = [ "Ubuntu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };

      time.timeZone = "America/Fortaleza";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "pt_BR.UTF-8";
        LC_IDENTIFICATION = "pt_BR.UTF-8";
        LC_MEASUREMENT = "pt_BR.UTF-8";
        LC_MONETARY = "pt_BR.UTF-8";
        LC_NAME = "pt_BR.UTF-8";
        LC_NUMERIC = "pt_BR.UTF-8";
        LC_PAPER = "pt_BR.UTF-8";
        LC_TELEPHONE = "pt_BR.UTF-8";
        LC_TIME = "pt_BR.UTF-8";
      };

      xdg.icons.fallbackCursorThemes = [ "BreezeX-RosePine-Linux" ];
      console.keyMap = "br-abnt2";

      services.upower.enable = true;

      security.polkit.enable = true;

      hardware = {
        enableAllFirmware = true;

        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;

        opengl = {
          enable = true;
          driSupport32Bit = true;
        };
      };
    };
}
