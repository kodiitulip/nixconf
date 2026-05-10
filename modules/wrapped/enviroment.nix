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
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      packages = {
        desktop =
          (inputs.wrappers.wrapperModules.niri.apply (_: {
            inherit pkgs;
            imports = [ self.wrapperModules.niri ];
            terminal = lib.getExe selfpkgs.terminal;
          })).wrapper;

        neovim = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
          imports = [ self.nixosModules.nixvim-conf ];
        };

        terminal =
          (inputs.wrappers.wrapperModules.kitty.apply {
            inherit pkgs;
            imports = [ self.wrapperModules.kitty ];
            shell = lib.getExe selfpkgs.environment;
          }).wrapper;

        environment = inputs.wrappers.lib.wrapPackage {
          inherit pkgs;
          package = selfpkgs.nushell;
          runtimeInputs = with pkgs; [
            selfpkgs.neovim
            selfpkgs.qalc

            # nix
            nil
            nixd
            statix
            alejandra
            manix
            nix-inspect
            nh

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
            fastfetch
            tree-sitter
            imagemagick
            imv
            ffmpeg-full
            yt-dlp
            lazygit
            starship
          ];
          env = {
            EDITOR = lib.getExe selfpkgs.neovim;
          };
        };

        nix-check-bin = pkgs.writeShellApplication {
          name = "nix-check-bin";
          text = ''$EDITOR "$(nix build "$1" --no-link --print-out-paths)/bin"'';
        };
      };
    };
}
