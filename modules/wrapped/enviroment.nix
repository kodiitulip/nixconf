{
  lib,
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages = {
        desktop =
          (inputs.wrappers.wrapperModules.niri.apply (_: {
            inherit pkgs;
            imports = [ self.wrapperModules.niri ];
            terminal = lib.getExe self'.packages.terminal;
            env = {
              EDITOR = lib.getExe self'.packages.neovim;
            };
          })).wrapper;

        neovim = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
          imports = [ self.nixosModules.nixvim-conf ];
        };

        terminal =
          (inputs.wrappers.wrapperModules.kitty.apply {
            inherit pkgs;
            imports = [ self.wrapperModules.kitty ];
            shell = lib.getExe self'.packages.environment;
          }).wrapper;

        environment = inputs.wrappers.lib.wrapPackage {
          inherit pkgs;
          package = self'.packages.nushell;
          runtimeInputs =
            (with self'.packages; [
              neovim
              qalc
              nh
            ])
            ++ (with pkgs; [
              # nix
              nil
              nixd
              statix
              alejandra
              manix
              nix-inspect

              # other
              file
              unzip
              zip
              p7zip
              killall
              sshfs
              fzf
              htop
              btop
              fd
              zoxide
              dust
              ripgrep
              neofetch
              tree-sitter
              imagemagick
              imv
              ffmpeg-full
              yt-dlp
              lazygit
              starship
            ]);
          env = {
            EDITOR = lib.getExe self'.packages.neovim;
          };
        };

        nix-check-bin = pkgs.writeShellApplication {
          name = "nix-check-bin";
          text = ''$EDITOR "$(nix build "$1" --no-link --print-out-paths)/bin"'';
        };
      };
    };
}
