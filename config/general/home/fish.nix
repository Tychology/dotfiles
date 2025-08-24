{
  host,
  username,
  ...
}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellInit = ''
      begin
        set -l oldpath
        source /etc/fish/setEnvironment.fish
        set PATH $oldpath $PATH
      end
    '';
    interactiveShellInit = ''
      set fish_greeting ""
      fastfetch
    '';
    shellAliases = import ./aliases/aliases.nix {inherit host username;};
  };
}
