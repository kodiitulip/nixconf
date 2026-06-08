{
  flake.nixosModules.nixvim-conf =
    { pkgs, lib, ... }:
    {
      plugins.grug-far = {
        enable = true;
        settings = {
          debounceMs = 1000;
          engine = "ripgrep";
          engines = {
            ripgrep = {
              path = lib.getExe pkgs.ripgrep;
              showReplaceDiff = true;
            };
          };
          maxSearchMatches = 2000;
          maxWorkers = 8;
          minSearchChars = 1;
          normalModeSearch = false;
        };
      };
    };
}
