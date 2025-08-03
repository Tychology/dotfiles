{
  lib,
  pkgs,
  username,
  host,
  flakeDir,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    #catppuccin.enable = true;
    settings = {
      #theme = "base16_transparent";
      editor = {
        auto-save = true;
        bufferline = "multiple";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
        lsp.display-inlay-hints = true;
      };
      keys = {
        insert = {
          "esc" = ["normal_mode" ":w"];
          "A-+" = [":append-output echo -n '|>'"];
          "A-minus" = [":append-output echo -n '->'"];
        };
        select = {
          "esc" = ["collapse_selection" "normal_mode" ":w"];
        };
        normal = {
          e = "expand_selection";
          E = "shrink_selection";
          #y = {y = ["extend_to_line_bounds" "yank" "normal_mode" "collapse_selection"];};
          #d = {d = ["extend_to_line_bounds" "yank" "delete_selection"];};
          #c = {c = ["extend_to_line_bounds" "yank" "delete_selection" "insert_mode"];};
          Z = {Z = ":wq";};
          "," = ["goto_line_end" ":append-output echo -n ';'"];
          esc = ["collapse_selection" "keep_primary_selection" ":w"];
          "A-+" = [":append-output echo -n '|>'"];
          "A-minus" = [":append-output echo -n '->'"];
        };
      };
    };
    languages.language-server = {
      # nixd = {command = "/run/current-system/sw/bin/nixd";};
      nixd = {
        command = lib.getExe pkgs.nixd;
        config = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }";
            };
            formatting = {
              command = "alejandra";
            };
            options = {
              nixos = {
                expr = "(builtins.getFlake \"git+file://${flakeDir}\").nixosConfigurations.\"${host}\".options";
              };
              home_manager = {
                expr = "(builtins.getFlake \"git+file://${flakeDir}\").homeConfigurations.\"${username}@${host}\".options";
              };
            };
          };
        };
      };
      nil = {command = "nil";};
    };
    languages.language = [
      {
        name = "gleam";
        auto-format = true;
        formatter = {command = "gleam format";};
      }
      {
        name = "nix";
        auto-format = true;
        formatter = {command = "alejandra";};
        language-servers = ["nixd"];
      }
      {
        name = "c";
        auto-format = true;
        formatter = {command = "clang-format";};
        indent = {
          tab-width = 4;
          unit = "\t";
        };
      }
      {
        name = "cpp";
        auto-format = true;
        formatter = {command = "clang-format";};
        indent = {
          tab-width = 4;
          unit = "\t";
        };
      }
      {
        name = "java";
        indent = {
          tab-width = 4;
          unit = "\t";
        };
      }
    ];
    themes = {
      catppuccin_mocha_transparent = {
        "inherits" = "catppuccin_mocha";
        "ui.background" = {};
      };
    };
  };
}
