# TODO: set this to be rose-pine theme instead
_:
let
  theme = {
    base00 = "#191724"; # base
    base01 = "#1f1d2e"; # surface
    base02 = "#26233a"; # overlay
    base03 = "#6e6a86"; # muted
    base04 = "#908caa"; # subtle
    base05 = "#e0def4"; # text
    base06 = "#eb6f92"; # love
    base07 = "#f6c177"; # gold
    base08 = "#ebbcba"; # rose
    base09 = "#31748f"; # pine
    base0A = "#9ccfd8"; # foam
    base0B = "#c4a7e7"; # iris
    base0C = "#21202e"; # highlight low
    base0D = "#403d52"; # highlight med
    base0E = "#524f67"; # highlight high
    base0F = "#e0def4"; # text
  };

  stripHash =
    name: str:
    if builtins.substring 0 1 str == "#" then
      builtins.substring 1 (builtins.stringLength str - 1) str
    else
      str;

  themeNoHash = builtins.mapAttrs stripHash theme;
in
{
  flake = {
    inherit theme themeNoHash;
  };
}
