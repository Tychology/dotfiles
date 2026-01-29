{
  pkgs,
  lib,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    rich-cli
    trash-cli
    mediainfo
    sshfs
    fuse
  ];
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    plugins =
      lib.genAttrs [
        "sudo"
        "starship"
        "chmod"
        "ouch"
        "wl-clipboard"
        "smart-paste"
        "smart-enter"
        "smart-filter"
        "recycle-bin"
        "rich-preview"
        "rsync"
        "mount"
      ] (name: builtins.getAttr name pkgs.yaziPlugins)
      // {
        folder-rules = ./yazi_plugins/folder-rules;
        gitui = ./yazi_plugins/gitui;
        sshfs = ./yazi_plugins/sshfs;
        kdeconnect-send = ./yazi_plugins/kdeconnect-send;
        pandoc = ./yazi_plugins/pandoc;
        open-with-cmd = ./yazi_plugins/open-with-cmd;
        bunny = ./yazi_plugins/bunny;
      };

    initLua = ''
      require("starship"):setup()
      require("recycle-bin"):setup()
      require("folder-rules"):setup()
      require("sshfs"):setup()

      require("bunny"):setup({
        hops = {
          { key = "/",          path = "/",                                    },
          { key = ".",          path = "~/dotfiles",                           },
          { key = "t",          path = "/tmp",                                 },
          { key = "n",          path = "/nix/store",     desc = "Nix store"    },
          { key = "~",          path = "~",              desc = "Home"         },
          { key = "m",          path = "~/Music",        desc = "Music"        },
          { key = "d",          path = "~/Downloads",    desc = "Downloads"      },
          { key = "D",          path = "~/Documents",    desc = "Documents"    },
          { key = "c",          path = "~/.config",      desc = "Config files" },
          { key = "u",          path = "~/uni", },
          { key = "r",          path = "~/repos", },
          { key = {"v", "u"},          path = "~/vaults/Main/Uni" },
          { key = { "l", "s" }, path = "~/.local/share", desc = "Local share"  },
          { key = { "l", "b" }, path = "~/.local/bin",   desc = "Local bin"    },
          { key = { "l", "t" }, path = "~/.local/state", desc = "Local state"  },
          -- key and path attributes are required, desc is optional
        },
        desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
        ephemeral = true, -- Enable ephemeral hops, default is true
        tabs = true, -- Enable tab hops, default is true
        notify = false, -- Notify after hopping, default is false
        fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
      })
    '';

    keymap = {
      mgr = {
        prepend_keymap = [
          # wl-clipboard
          {
            on = "Y";
            run = "plugin wl-clipboard --copy";
          }

          # chmod
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }

          # ouch
          {
            on = "C";
            run = "plugin ouch";
            desc = "Compress with ouch";
          }

          # gitui
          {
            on = ["g" "i"];
            run = "plugin gitui";
            desc = "run gitui";
          }

          # smart paste
          {
            on = "p";
            run = "plugin smart-paste";
            desc = "Paste into the hovered directory or CWD";
          }

          # smart filter
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }

          # smart enter
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }

          # kdeconnect
          {
            on = "K";
            run = "plugin kdeconnect-send";
            desc = "Send selected files via KDE Connect";
          }

          # pandoc
          {
            on = ["c" "p"];
            run = "plugin pandoc";
            desc = "Pandoc: Interactive Convert";
          }

          # open-with-cmd
          {
            on = "o";
            run = "plugin open-with-cmd -- block";
            desc = "Open with command in the terminal";
          }

          {
            on = "O";
            run = "plugin open-with-cmd";
            desc = "Open with command";
          }

          # recycle bin
          {
            on = ["R" "b"];
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }

          # rsync
          {
            on = ["R" "s"];
            run = "plugin rsync";
            desc = "Copy files using rsync";
          }

          # mount
          {
            on = ["M" "M"];
            run = "plugin mount";
            desc = "Mount";
          }

          # sshfs
          {
            on = ["M" "s"];
            run = "plugin sshfs -- menu";
            desc = "Open SSHFS options";
          }

          # bunny
          {
            on = "b";
            run = "plugin bunny";
            desc = "Start bunny";
          }

          # sudo cp/mv
          {
            on = ["R" "p" "p"];
            run = "plugin sudo -- paste";
            desc = "sudo paste";
          }

          # sudo cp/mv --force
          {
            on = ["R" "P"];
            run = "plugin sudo -- paste --force";
            desc = "sudo paste";
          }

          # sudo mv
          {
            on = ["R" "r"];
            run = "plugin sudo -- rename";
            desc = "sudo rename";
          }

          # sudo ln -s (absolute-path)
          {
            on = ["R" "p" "l"];
            run = "plugin sudo -- link";
            desc = "sudo link";
          }

          # sudo ln -s (relative-path)
          {
            on = ["R" "p" "r"];
            run = "plugin sudo -- link --relative";
            desc = "sudo link relative path";
          }

          # sudo ln
          {
            on = ["R" "p" "L"];
            run = "plugin sudo -- hardlink";
            desc = "sudo hardlink";
          }

          # sudo touch/mkdir
          {
            on = ["R" "a"];
            run = "plugin sudo -- create";
            desc = "sudo create";
          }

          # sudo trash
          {
            on = ["R" "d"];
            run = "plugin sudo -- remove";
            desc = "sudo trash";
          }

          # sudo delete
          {
            on = ["R" "D"];
            run = "plugin sudo -- remove --permanently";
            desc = "sudo delete";
          }

          # sudo chmod
          {
            on = ["R" "m"];
            run = "plugin sudo -- chmod";
            desc = "sudo chmod";
          }
        ];
      };
    };

    settings = {
      plugin.prepend_previewers = [
        {
          mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
          run = "ouch";
        }

        {
          url = "*.csv";
          run = "rich-preview";
        }

        # for markdown (.md) files
        {
          url = "*.md";
          run = "rich-preview";
        }

        # for restructured text (.rst) files
        {
          url = "*.rst";
          run = "rich-preview";
        }

        # for jupyter notebooks (.ipynb)
        {
          url = "*.ipynb";
          run = "rich-preview";
        }

        # for json (.json) files
        {
          url = "*.json";
          run = "rich-preview";
        }

        # Replace magick, image, video with mediainfo
        {
          mime = "{audio,video,image}/*";
          run = "mediainfo";
        }
        {
          mime = "application/subrip";
          run = "mediainfo";
        }
      ];
      # open = {
      #   rules = [
      #     {mime = "text/*" use = "edit"};
      #   ];
      # }
    };
  };
}
