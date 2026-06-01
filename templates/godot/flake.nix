{
  description = "Godot development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    mkgodot.url = "github:kodiitulip/mkgodot";
  };

  outputs =
    {
      self,
      nixpkgs,
      mkgodot,
      ...
    }:
    let
      inherit (nixpkgs) lib legacyPackages;
      forAllSystems =
        func: lib.genAttrs lib.systems.flakeExposed (system: func legacyPackages.${system} system);
    in
    {
      packages = forAllSystems (
        pkgs: system:
        let
          mkGodot = pkgs.callPackage mkgodot.lib.mkGodot { };
          mkNixosPatch = pkgs.callPackage mkgodot.lib.mkNixosPatch { };
          pname = "new-godot-project";
          version = "1.0.0";
        in
        {
          default = self.packages.${system}.linux;

          linux = mkGodot {
            inherit pname version;
            src = ./.;
            preset = "linux";
          };

          nixos = mkNixosPatch {
            inherit version pname;
            src = self.packages.${system}.linux;
          };

          windows = mkGodot {
            inherit pname version;
            src = ./.;
            preset = "windows";
          };
        }
      );

      devShell = forAllSystems (
        pkgs: system:
        pkgs.mkShell {
          buildInputs = with pkgs; [ godot ];
        }
      );
    };
}
