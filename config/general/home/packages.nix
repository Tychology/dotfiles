{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    speedtest-cli
    wiki-tui
    pandoc
    opencode
  ];
}
