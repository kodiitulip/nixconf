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
          package = pkgs.nushell;
          runtimeInputs = [
            # nix
            pkgs.nil
            pkgs.nixd
            pkgs.statix
            pkgs.alejandra
            pkgs.manix
            pkgs.nix-inspect
            self'.packages.nh

            # other
            pkgs.file
            pkgs.unzip
            pkgs.zip
            pkgs.p7zip
            pkgs.killall
            pkgs.sshfs
            pkgs.fzf
            pkgs.htop
            pkgs.btop
            pkgs.fd
            pkgs.zoxide
            pkgs.dust
            pkgs.ripgrep
            pkgs.neofetch
            pkgs.tree-sitter
            pkgs.imagemagick
            pkgs.imv
            pkgs.ffmpeg-full
            pkgs.yt-dlp
            pkgs.lazygit

            # wrapped
            self'.packages.neovim
            self'.packages.qalc
          ];
          env = {
            EDITOR = lib.getExe self'.packages.neovim;
          };
        };
      };
    };
}
