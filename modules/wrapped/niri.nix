{ self, inputs, ... }:
{
  flake.wrapperModules.niri =
    { config, lib, ... }:
    {
      options.terminal = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
      };
      config = {
        v2-settings = true;
        settings =
          let
            noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctalia-shell;
            self' = self.packages.${config.pkgs.stdenv.hostPlatform.system};
          in
          {
            prefer-no-csd = _: { };
            screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";

            environment = {
              QT_QPA_PLATFORM = "wayland";
            };

            cursor = {
              xcursor-theme = "BreezeX-RosePine-Linux";
              xcursor-size = 24;

              hide-when-typing = _: { };
              hide-after-inactive-ms = 1000;
            };

            hotkey-overlay = {
              # skip-at-startup = _: { };
              hide-not-bound = _: { };
            };

            input = {
              focus-follows-mouse = _: { };

              keyboard = {
                xkb = {
                  layout = "br";
                  options = "compose:rctrl";
                };
                numlock = _: { };
                repeat-rate = 40;
                repeat-delay = 250;
              };

              touchpad = {
                natural-scroll = _: { };
                tap = _: { };
              };

              mouse = {
                accel-profile = "flat";
              };
            };

            binds = {
              "Mod+Return" = _: {
                props = {
                  hotkey-overlay-title = "Open Terminal";
                  repeat = false;
                };
                content.spawn = config.terminal;
              };

              "Mod+Q".close-window = _: { };
              "Mod+F".maximize-column = _: { };
              "Mod+G".fullscreen-window = _: { };
              "Mod+Shift+F".toggle-window-floating = _: { };
              "Mod+C".center-column = _: { };

              "Mod+H".focus-column-left = _: { };
              "Mod+L".focus-column-right = _: { };
              "Mod+K".focus-window-up = _: { };
              "Mod+J".focus-window-down = _: { };

              "Mod+Left".focus-column-left = _: { };
              "Mod+Right".focus-column-right = _: { };
              "Mod+Up".focus-window-up = _: { };
              "Mod+Down".focus-window-down = _: { };

              "Mod+Shift+H".move-column-left = _: { };
              "Mod+Shift+L".move-column-right = _: { };
              "Mod+Shift+K".move-window-up = _: { };
              "Mod+Shift+J".move-window-down = _: { };

              "Mod+1".focus-workspace = "w0";
              "Mod+2".focus-workspace = "w1";
              "Mod+3".focus-workspace = "w2";
              "Mod+4".focus-workspace = "w3";
              "Mod+5".focus-workspace = "w4";
              "Mod+6".focus-workspace = "w5";
              "Mod+7".focus-workspace = "w6";
              "Mod+8".focus-workspace = "w7";
              "Mod+9".focus-workspace = "w8";
              "Mod+0".focus-workspace = "w9";

              "Mod+Shift+1".move-column-to-workspace = "w0";
              "Mod+Shift+2".move-column-to-workspace = "w1";
              "Mod+Shift+3".move-column-to-workspace = "w2";
              "Mod+Shift+4".move-column-to-workspace = "w3";
              "Mod+Shift+5".move-column-to-workspace = "w4";
              "Mod+Shift+6".move-column-to-workspace = "w5";
              "Mod+Shift+7".move-column-to-workspace = "w6";
              "Mod+Shift+8".move-column-to-workspace = "w7";
              "Mod+Shift+9".move-column-to-workspace = "w8";
              "Mod+Shift+0".move-column-to-workspace = "w9";
              "Mod+S" = {
                props.hotkey-overlay-title = "Open App Launcher";
                content.spawn-sh = "${noctaliaExe} ipc call launcher toggle";
              };
              "Mod+V" = {
                props.hotkey-overlay-title = "alsa-utils Capture Toggle";
                content.spawn-sh = "${config.pkgs.alsa-utils}/bin/amixer sset Capture toggle";
              };
              "XF86AudioRaiseVolume" = {
                props.hotkey-overlay-title = "Raise Volume";
                content.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
              };
              "XF86AudioLowerVolume" = {
                props.hotkey-overlay-title = "Lower Volume";
                content.spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
              };

              "Mod+Ctrl+H".set-column-width = "-5%";
              "Mod+Ctrl+L".set-column-width = "+5%";
              "Mod+Ctrl+J".set-window-height = "-5%";
              "Mod+Ctrl+K".set-window-height = "+5%";

              "Mod+WheelScrollDown".focus-column-left = _: { };
              "Mod+WheelScrollUp".focus-column-right = _: { };
              "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
              "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

              "Mod+Ctrl+S".spawn-sh =
                "${lib.getExe config.pkgs.grim} -l 0 - | ${config.pkgs.wl-clipboard}/bin/wl-copy";

              "Mod+Shift+E".spawn-sh =
                "${config.pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe config.pkgs.swappy} -f -";

              "Mod+Shift+S".spawn-sh = lib.getExe (
                config.pkgs.writeShellApplication {
                  name = "screenshot";
                  text = ''${lib.getExe config.pkgs.grim} -g "$(${lib.getExe config.pkgs.slurp} -w 0)" - | ${config.pkgs.wl-clipboard}/bin/wl-copy'';
                }
              );

              "Print" = _: {
                props.repeat = false;
                props.hotkey-overlay-title = "Screenshot";
                content.screenshot = _: { };
              };
              "Mod+Print" = _: {
                props.repeat = false;
                props.hotkey-overlay-title = "Screenshot Window";
                content.screenshot-window = _: { };
              };
              "Mod+Alt+Print" = _: {
                props.repeat = false;
                props.hotkey-overlay-title = "Screenshot Screen";
                content.screenshot-screen = _: { };
              };

              "Mod+d".spawn-sh = self.mkWhichKeyExe config.pkgs [
                {
                  key = "w";
                  desc = "Wifi";
                  cmd = "${noctaliaExe} ipc call wifi togglePanel";
                }
                {
                  key = "z";
                  desc = "Zen Browser";
                  cmd = "${lib.getExe self'.zen}";
                }
                {
                  key = "d";
                  desc = "Discord";
                  cmd = "discord";
                }
                {
                  key = "m";
                  desc = "Youtube Music";
                  cmd = "pear-desktop";
                }
                {
                  key = "s";
                  desc = "Pavucontrol";
                  cmd = "${lib.getExe config.pkgs.pavucontrol}";
                }
              ];
            };

            layout = {
              gaps = 5;

              focus-ring = {
                width = 2;
                active-color = "${self.theme.base09}";
              };
            };

            workspaces =
              let
                settings = {
                  layout.gaps = 5;
                };
              in
              {
                "w0" = settings;
                "w1" = settings;
                "w2" = settings;
                "w3" = settings;
                "w4" = settings;
                "w5" = settings;
                "w6" = settings;
                "w7" = settings;
                "w8" = settings;
                "w9" = settings;
              };

            xwayland-satellite.path = lib.getExe config.pkgs.xwayland-satellite;

            spawn-at-startup = [
              noctaliaExe
              (lib.getExe (
                config.pkgs.writeShellScriptBin "wallpaper" "${lib.getExe config.pkgs.swaybg} -i ${self.wallpaper} -m fill"
              ))
            ];
          };
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        imports = [ self.wrapperModules.niri ];
      };
    };
}
