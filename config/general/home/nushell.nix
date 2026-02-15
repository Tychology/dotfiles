{
  lib,
  pkgs-unstable,
  pkgs,
  host,
  username,
  ...
}: {
  programs.nushell = {
    enable = true;
    package = pkgs-unstable.nushell;
    shellAliases = import ./aliases/aliases.nix {inherit host username;};
    settings = {
      show_banner = false;
      completions.external = {
        enable = true;
        max_results = 200;
      };
    };

    extraConfig = lib.mkAfter ''
      if ($nu.is-interactive) {
        fastfetch
      }
    '';

    environmentVariables = {
      EDITOR = "hx";
    };
  };
}
