{
  host,
  username,
  ...
}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    interactiveShellInit = ''
      set fish_greeting ""
      fastfetch
    '';
    shellAliases = import ./aliases/aliases.nix {inherit host username;};
  };
}
