{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      lazymcOverlay = final: prev: {
        lazymc = prev.lazymc.overrideAttrs (old: rec {
          version = "0.2.10";
          src = prev.fetchFromGitHub {
            owner = "timvisee";
            repo = "lazymc";
            rev = "v${version}";
            hash = "sha256-IObLjxuMJDjZ3M6M1DaPvmoRqAydbLKdpTQ3Vs+B9Oo=";
          };
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-Tx+Bof4NtVd7AlYMS6veLiT/9vBXPIRVpMecoW7SpfM=";
          };
        });
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ lazymcOverlay ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.lazymc ];
      };
    };
}
