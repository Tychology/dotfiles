{
  lib,
  pkgs,
  host,
  username,
  ...
}: {
  programs.nushell = {
    enable = true;
    shellAliases = {
      y = "yy";
      x = "hx";
      cd = "z";
      g = "gitui";
      gf = "git pull";
      gp = "git push";
      ga = "git add .";

      ".." = "cd ..";
      "cd.." = "cd ..";
    };

    extraConfig = lib.mkAfter ''
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
                            "path": {
                              from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                              to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
                            }
                          }
                          | merge ($env.ENV_CONVERSIONS? | default {})
                          | get -i $key
                          | get -i from_string
                          | default {$in}
                      ) $value
                      return [ $key $value ]
                  }
                  | into record
                  | load-env
              }
          )
    '';
  };
}
