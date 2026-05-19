{
  flake.nixosModules.starship =
    { lib, config, ... }:
    {
      hjem.users.${config.preferences.user.name}.rum.programs.starship = {
        enable = true;
        integrations.nushell.enable = true;
        transience.enable = true;
        settings = {
          add_newline = true;
          command_timeout = 1000;
          format = lib.concatStrings [
            "[](fg:overlay)"
            "$sudo"
            "$username"
            "[](fg:overlay) "
            "$directory"
            "$git_branch"
            "$git_status"
            "$fill"
            "$bun"
            "$c"
            "$elixir"
            "$elm"
            "$golang"
            "$haskell"
            "$java"
            "$julia"
            "$nodejs"
            "$nim"
            "$rust"
            "$scala"
            "$conda"
            "$python"
            "$direnv"
            "$time\n"
            "$character"
          ];
          palettes.rose-pine = {
            foam = "#9ccfd8";
            gold = "#f6c177";
            iris = "#c4a7e7";
            love = "#eb6f92";
            overlay = "#26233a";
            pine = "#31748f";
            rose = "#ebbcba";
          };
          palette = "rose-pine";
          profiles.transient = lib.concatStrings [
            "[](fg:overlay)"
            "$sudo"
            "[ 󰧱 ](bg:overlay fg:iris)"
            "[](fg:overlay) "
            "$fill"
            "$time\n"
            " [∙](bold fg:iris) "
          ];
          profiles.sudo_prompt = lib.concatStrings [
            "[](fg:overlay)[  ](bg:overlay fg:rose)[](fg:overlay) "
            "[](fg:rose) "
          ];
          continuation_prompt = " [∙](bold fg:iris) ";
          character = {
            format = " $symbol ";
            symbol = "[󱞪](bold fg:iris)";
            success_symbol = "[󱞪](bold fg:iris)";
            error_symbol = "[󱞪](bold fg:love)";
          };
          fill = {
            style = "fg:overlay";
            symbol = "=";
          };
          username = {
            disabled = false;
            format = "[ 󰧱 $user ]($style)";
            show_always = true;
            style_root = "bg:overlay fg:love";
            style_user = "bg:overlay fg:iris";
          };
          sudo = {
            disabled = false;
            format = "[ $symbol]($style)";
            style = "bg:overlay fg:rose";
            symbol = "";
          };
          git_branch = {
            format = "[ $symbol $branch ]($style)";
            style = "fg:foam";
            symbol = "";
          };
          git_status = {
            ahead = "⇡\($count\)";
            behind = "⇣\($count\)";
            deleted = "✘\($count\)";
            disabled = false;
            diverged = "⇕\[⇡\($ahead_count\)⇣\($behind_count\)\]";
            format = "([$all_status$ahead_behind ]($style))";
            modified = "[!\($count\)](fg:gold)";
            renamed = "[»\($count\)](fg:gold)";
            staged = "[++\($count\)](fg:gold)";
            stashed = "[\$](fg:gold)";
            style = "fg:love";
            untracked = "[?\($count\)](fg:gold)";
            up_to_date = "[✓](bg:overlay fg:foam)";
          };
          directory = {
            format = "[](fg:overlay)[ $path ]($style)[](fg:overlay) ";
            style = "bg:overlay fg:pine";
            truncation_length = 3;
            truncation_symbol = "…/";
            substitutions = {
              Blender = "  ";
              Documents = " 󰈙 ";
              Downloads = "  ";
              Godot = "  ";
              Java = "  ";
              Minecraft = " 󰍳 ";
              Music = "  ";
              Pictures = "  ";
              Projects = "  ";
              Python = "  ";
              Rust = "  ";
              Web = "  ";
              Streaming = " 󰄄 ";
            };
          };
          time = {
            disabled = false;
            format = " [](fg:overlay)[ $time 󰴈 ]($style)[](fg:overlay)";
            style = "bg:overlay fg:rose";
            time_format = "%R";
          };
          direnv = {
            disabled = false;
            format = " [](fg:overlay)[ $symbol ($allowed $loaded) ]($style)[](fg:overlay)";
            symbol = "";
            style = "bg:overlay fg:pine";
            allowed_msg = "󰄬";
            not_allowed_msg = "";
            denied_msg = "";
            loaded_msg = "";
            unloaded_msg = "";
          };
        };
      };
    };
}
