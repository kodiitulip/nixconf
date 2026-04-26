{ self, ... }:
{
  flake.nixosModules.nushell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      username = config.preferences.user.name;
    in
    {
      imports = [ self.nixosModules.starship ];
      rum.programs = {
        zoxide = {
          enable = true;
          integrations.nushell.enable = true;
        };
        nushell = {
          enable = true;
          aliases = {
            btw = ''print "I use NixOS, btw"'';
            vi = "nvim";
            vim = "nvim";

            gs = "git status";
            ga = "git add";
            gc = "git commit -m";
            gp = "git push";
            gb = "git branch";
            gsw = "git switch";
            gd = "git diff";
            gcl = "git clone";

            e = "exit";
            lg = "lazygit";
            reload = "exec nu";
            gw = "./gradlew";
            cr = "cargo run";
            crq = "cr --quiet";
            cb = "cargo build";
            cbq = "cb --quiet";
            ct = "cargo test";
            ctq = "ct --quiet";
            ".." = "z ..";
            "..." = "z ../..";
            "3.." = "z ../../..";
            "4.." = "z ../../../..";
            "5.." = "z ../../../../";

            garbage-collect = "sudo nix-collect-garbage -d";
            rebuild-persephone = "sudo nixos-rebuild switch --flake ~/nixconf#persephone";

            julia-join = "sudo zerotier-cli join bb720a5aaedee869";
            julia-leave = "sudo zerotier-cli leave bb720a5aaedee869";

            ztls = "sudo zerotier-cli listnetworks";
          };

          plugins = with pkgs.nushellPlugins; [
            units
            semver
            query
            formats
          ];

          settings = {
            show_banner = false;
            buffer_editor = "nvim";
            use_kitty_protocol = true;
            edit_mode = "vi";
            cursor_shape = {
              vi_insert = "line";
              vi_normal = "blink_block";
            };
            completions.external = {
              enable = true;
              max_results = 200;
            };
            keybindings = [
              {
                name = "lfcd";
                modifier = "control";
                keycode = "char_o";
                mode = [
                  "emacs"
                  "vi_normal"
                  "vi_insert"
                ];
                event = {
                  send = "executehostcommand";
                  cmd = "lfcd";
                };
              }
            ];
          };

          extraConfig = ''
            $env.PATH = ($env.PATH | append '/home/${username}/.nuscripts' | append '/home/${username}/.bun/bin')

            def --env get-env [name] { $env | get $name }
            def --env set-env [name, value] { load-env { $name: $value } }
            def --env unset-env [name] { hide-env $name }


            # Edit NixOS Config
            def "config nix" [] {
              cd ~/nixconf; nvim; cd -
            }

            def greeter []: nothing -> string {
              $"\n\t(ansi '#5BCFFA')Ｈ(ansi '#F5ABB9')ｅ(ansi '#FFFFFF')ｌ(ansi '#F5ABB9')ｌ(ansi '#5BCFFA')ｏ　(ansi '#5BCFFA')Ｋ(ansi '#F5ABB9')ｏ(ansi '#FFFFFF')ｄ(ansi '#F5ABB9')ｉ(ansi '#5BCFFA')ｅ\t(ansi '#5BCFFA') (ansi '#F5ABB9')"
            }

            def c [] {clear; greeter}

            print (greeter)

            def "bumpversion packwiz" [version: string] {
              if (not ('./pack.toml' | path exists)) {
                print "No pack.toml found"
                return
              }
              cat ./pack.toml | str replace -r 'version = "(.*)"' $'version = "($version)"' | save -f ./pack.toml
            }

            export-env { load-env {
                VISUAL = "nvim"
                EDITOR = "nvim"
                SUDO_PROMPT = (^${lib.getExe pkgs.starship} prompt --profile=sudo_prompt --terminal-width (term size).columns)
                STARSHIP_LOG = "error"
                NU_EXPERIMENTAL_OPTIONS = "native-clip"

                PROMPT_MULTILINE_INDICATOR: (^${lib.getExe pkgs.starship} prompt --continuation)
                TRANSIENT_PROMPT_MULTILINE_INDICATOR: (^${lib.getExe pkgs.starship} prompt --continuation)

                TRANSIENT_PROMPT_INDICATOR: ""

                TRANSIENT_PROMPT_COMMAND: {||
                  (
                    let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
                    ^${lib.getExe pkgs.starship} prompt
                      --profile=transient
                      --cmd-duration $cmd_duration
                      $"--status=($env.LAST_EXIT_CODE)"
                      --terminal-width (term size).columns
                      --jobs (job list | length)
                  )
                }
            }}

            source ${
              pkgs.runCommand "carapace-init-nu" { }
                ''${lib.getExe pkgs.carapace} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"''
            }
          '';
        };
      };
    };
}
