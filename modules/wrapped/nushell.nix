{ self, inputs, ... }:
{
  flake.wrapperModules.nushell =
    { pkgs, lib, ... }:
    {
      config = {
        "config.nu".content = ''
          load-env {
            "EDITOR": "nvim"
            "NU_EXPERIMENTAL_OPTIONS": "native-clip"
            "STARSHIP_LOG": "error"
            "SUDO_PROMPT": ((^starship prompt --profile=sudo_prompt --terminal-width (term size).columns))
            "VISUAL": "nvim"
          }

          $env.config.buffer_editor = "nvim"
          $env.config.completions.external.enable = true
          $env.config.completions.external.max_results = 200
          $env.config.cursor_shape.vi_insert = "line"
          $env.config.cursor_shape.vi_normal = "blink_block"
          $env.config.edit_mode = "vi"
          $env.config.show_banner = false
          $env.config.use_kitty_protocol = true
          $env.PATH = ($env.PATH | append '/home/kodie/.nuscripts' | append '/home/kodie/.bun/bin')

          def --env get-env [name] { $env | get $name }
          def --env set-env [name, value] { load-env { $name: $value } }
          def --env unset-env [name] { hide-env $name }

          # Edit NixOS Config
          def "config nix" [] {
            cd ~/nixconf; nvim; cd -
          }

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

          source ${pkgs.runCommand "zoxide-init-nu" { } ''${lib.getExe pkgs.zoxide} init nushell >> "$out"''}
          use ${pkgs.runCommand "starship-init-nu" { } ''${lib.getExe pkgs.starship} init nu >> "$out" ''}
          source ${
            pkgs.runCommand "carapace-init-nu" { }
              ''${lib.getExe pkgs.carapace} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"''
          }

          $env.config = ($env.config? | default {})
          $env.config.hooks = ($env.config.hooks? | default {})
          $env.config.hooks.pre_prompt = (
            $env.config.hooks.pre_prompt?
            | default []
            | append {||
              ${lib.getExe pkgs.direnv} export json
              | from json --strict
              | default {}
              | items {|key, value|
                let value = do (
                  {
                    "PATH": {
                      from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                      to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
                    }
                  }
                  | merge ($env.ENV_CONVERSIONS? | default {})
                  | get ([[value, optional, insensitive]; [$key, true, true] [from_string, true, false]] | into cell-path)
                  | if ($in | is-empty) { {|x| $x} } else { $in }
                ) $value
                return [ $key $value ]
              }
              | into record
              | load-env
            }
          )

          alias btw = 'print "I use NixOS, btw"'
          alias vi = "nvim"
          alias vim = "nvim"

          alias e = exit
          alias c = clear
          alias lg = lazygit
          alias reload = exec nu
          alias gw = "./gradlew"
          alias cr = cargo run
          alias crq = cr --quiet
          alias cb = cargo build
          alias cbq = cb --quiet
          alias ct = cargo test
          alias ctq = ct --quiet
          alias ".." = z ..
          alias "..." = z ../..
          alias "3.." = z ../../..
          alias "4.." = z ../../../..
          alias "5.." = z ../../../../

          alias garbage-collect = sudo nix-collect-garbage -d
          alias rebuild-hades = sudo nixos-rebuild switch --flake ~/nixconf#hades
          alias julia-join = sudo zerotier-cli join bb720a5aaedee869
          alias julia-leave = sudo zerotier-cli leave bb720a5aaedee869
          alias ztls = sudo zerotier-cli listnetworks
        '';
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.nushell =
        (inputs.wrappers.wrapperModules.nushell.apply {
          inherit pkgs;
          imports = [ self.wrapperModules.nushell ];
        }).wrapper;
    };
}
