{
  description = "A simple Rust project flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    naersk.url = "github:nix-community/naersk";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      naersk,
      fenix,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      naerskLib = pkgs.callPackage naersk { };
      inherit (fenix.stable) toolchain rust-src;
    in
    {

      devShells."x86_64-linux".default = pkgs.mkShell {
        buildInputs = [ toolchain ];

        nativeBuildInputs = [ pkgs.pkg-config ];

        env.RUST_SRC_PATH = "${rust-src}/lib/rustlib/src/rust/library";
      };

      packages."x86_64-linux".default =
        (naerskLib.override {
          cargo = toolchain;
          rustc = toolchain;
        }).buildPackage
          {
            src = ./.;
            buildInputs = [ ];
            nativeBuildInputs = [ pkgs.pkg-config ];
          };

    };
}
