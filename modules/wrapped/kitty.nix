{
  self,
  inputs,
  ...
}:
{
  flake.wrapperModules.kitty = _: {
    config = {
      settings = {
        enable_audio_bell = "no";

        font_size = 10;
        font_family = "FiraCode Nerd Font Mono";

        allow_remote_control = "yes";
        shell_integration = "enabled";

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = ''" {index} {title} "'';

        cursor_trail = 3;

        map = [
          "alt+1 goto_tab 1"
          "alt+2 goto_tab 2"
          "alt+3 goto_tab 3"
          "alt+4 goto_tab 4"
          "alt+5 goto_tab 5"
          "alt+6 goto_tab 6"
          "alt+7 goto_tab 7"
          "alt+8 goto_tab 8"
          "alt+9 goto_tab 9"
          "ctrl+shift+w close_tab"
          "ctrl+t new_tab_with_cwd"
          "ctrl+shift+t new_tab"
        ];

        foreground = self.theme.base05;
        background = self.theme.base00;

        cursor = self.theme.base0E;
        cursor_text_color = self.theme.base05;

        selection_foreground = self.theme.base05;
        selection_background = self.theme.base0D;

        active_tab_foreground = self.theme.base05;
        active_tab_background = self.theme.base02;
        inactive_tab_foreground = self.theme.base03;
        inactive_tab_background = self.theme.base00;

        active_border_color = self.theme.base09;
        inactive_border_color = self.theme.base0D;

        color0 = self.theme.base02;
        color8 = self.theme.base03;

        color1 = self.theme.base06;
        color9 = self.theme.base06;

        color2 = self.theme.base09;
        color10 = self.theme.base09;

        color3 = self.theme.base07;
        color11 = self.theme.base07;

        color4 = self.theme.base0A;
        color12 = self.theme.base0A;

        color5 = self.theme.base0B;
        color13 = self.theme.base0B;

        color6 = self.theme.base08;
        color14 = self.theme.base08;

        color7 = self.theme.base05;
        color15 = self.theme.base05;
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.kitty =
        (inputs.wrappers.wrapperModules.kitty.apply {
          inherit pkgs;
          imports = [ self.wrapperModules.kitty ];
        }).wrapper;
    };
}
