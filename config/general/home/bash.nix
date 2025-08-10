{
  host,
  username,
  ...
}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initExtra = ''
      fastfetch
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
      eval "$(zoxide init bash)"
    '';
    shellAliases = import ./aliases/aliases.nix {inherit host username;};
  };
}
