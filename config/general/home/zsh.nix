{
  config,
  lib,
  pkgs,
  host,
  username,
  ...
}: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VNTR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initContent = lib.mkMerge [
      ''
          zstyle ":completion:*" menu select
          zstyle ":completion:*" matcher-list "" "m:{a-z0A-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
          if type nproc &>/dev/null; then
            export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
          fi
          bindkey '^[[3~' delete-char                     # Key Del
          bindkey '^[[5~' beginning-of-buffer-or-history  # Key Page Up
          bindkey '^[[6~' end-of-buffer-or-history        # Key Page Down
          bindkey '^[[1;3D' backward-word                 # Key Alt + Left
          bindkey '^[[1;3C' forward-word                  # Key Alt + Right
          bindkey '^[[H' beginning-of-line                # Key Home
          bindkey '^[[F' end-of-line                      # Key End
          # neofetch
          fastfetch
          if [ -f $HOME/.zshrc-personal ]; then
            source $HOME/.zshrc-personal
          fi

        function yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
           eval "$(zoxide init bash)"
           eval "$(starship init zsh)"
      ''

      (lib.mkBefore
        ''
          HISTFILE=~/.histfile
          HISTSIZE=1000
          SAVEHIST=1000
          setopt autocd nomatch
          unsetopt beep extendedglob notify
          autoload -Uz compinit
          compinit
        '')
    ];

    sessionVariables = {
      EDITOR = "hx";
    };
    shellAliases = {
      y = "yy";
      x = "hx";
      cd = "z";
      yz = "yy ~/zaneyos";
      eh = "hx ~/zaneyos/hosts/${host}/home.nix";
      es = "hx ~/zaneyos/hosts/${host}/config.nix";

      sv = "sudo nvim";
      fr = "nh os switch --hostname ${host} /home/${username}/zaneyos";
      fu = "nh os switch --hostname ${host} --update /home/${username}/zaneyos";
      zu = "sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/raw/main/install-zaneyos.sh)";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v = "nvim";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -lh --icons --grid --group-directories-first";
      la = "eza -lah --icons --grid --group-directories-first";
      ".." = "cd ..";
    };
  };
}
