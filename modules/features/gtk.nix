{
  flake.nixosModules.gtk =
    {
      pkgs,
      lib,
      ...
    }:
    let
      theme-name = "rose-pine-gtk";
      theme-package = pkgs.rose-pine-gtk-theme;
      icon-theme-name = "rose-pine-icons";
      icon-theme-package = pkgs.rose-pine-icon-theme;
      cursor-theme-name = "BreezeX-RosePine-Linux";
      cursor-theme-package = pkgs.rose-pine-cursor;

      gtksettings = ''
        [Settings]
        gtk-icon-theme-name = ${icon-theme-name}
        gtk-theme-name = ${theme-name}
        gtk-cursor-theme-name = ${cursor-theme-name}
      '';
    in
    {
      environment = {
        etc = {
          "xdg/gtk-3.0/settings.ini".text = gtksettings;
          "xdg/gtk-4.0/settings.ini".text = gtksettings;
        };
      };

      environment.variables = {
        GTK_THEME = theme-name;
      };

      programs = {
        dconf = {
          enable = lib.mkDefault true;
          profiles = {
            user = {
              databases = [
                {
                  lockAll = false;
                  settings = {
                    "org/gnome/desktop/interface" = {
                      gtk-theme = theme-name;
                      icon-theme = icon-theme-name;
                      cursor-theme = cursor-theme-name;
                      color-scheme = "prefer-dark";
                    };
                  };
                }
              ];
            };
          };
        };
      };

      environment.systemPackages = [
        theme-package
        icon-theme-package
        cursor-theme-package

        pkgs.gtk3
        pkgs.gtk4
      ];
    };
}
