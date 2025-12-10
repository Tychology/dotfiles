{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    bitwarden-cli
    speedtest-cli
    github-cli
    wiki-tui
    pandoc
    opencode
  ];
}
