{
  flake.templates = {
    rust-project = {
      path = ./rust;
      description = "A simple Rust project flake";
    };
    dioxus = {
      path = ./dioxus;
      description = "A Dioxus project flake";
    };
    godot = {
      path = ./godot;
      description = "Godot development environment";
    };
  };
}
