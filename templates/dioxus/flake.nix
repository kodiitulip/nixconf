{
  description = "A Dioxus project flake";

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
        buildInputs = with pkgs; [
          toolchain
          dioxus-cli
          tailwindcss_4

          # Requirements for the web build of dioxus
          wasm-bindgen-cli_0_2_121
          lld

          # Requirements for the desktop build of dioxus
          glib
          gtk3
          gdk-pixbuf
          cairo
          pango
          atk
          openssl
          libsoup_3
          webkitgtk_4_1
          xdotool
        ];

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
            buildInputs = with pkgs; [
              tailwindcss_4
              dioxus-cli

              # Requirements for the web build of dioxus
              wasm-bindgen-cli_0_2_121
              lld

              # Requirements for the desktop build of dioxus
              glib
              gtk3
              gdk-pixbuf
              cairo
              pango
              atk
              openssl
              libsoup_3
              webkitgtk_4_1
              xdotool
            ];
            nativeBuildInputs = [ pkgs.pkg-config ];
          };

    };
}
