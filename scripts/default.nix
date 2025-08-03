{
  pkgs,
  variables,
  flakeDir,
  ...
}: let
  # Get the list of files in the current directory
  files = builtins.readDir ./.;

  # Filter out `default.nix` and any non-Nix files
  nixFiles = builtins.filter (name: name != "default.nix" && builtins.match ".*\\.nix" name != null) (builtins.attrNames files);
in {
  home.packages = builtins.map (file: import (./. + "/${file}") {inherit pkgs variables flakeDir;}) nixFiles;
}
