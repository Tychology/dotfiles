{
  pkgs,
  flakeDir,
  ...
}:
pkgs.writeShellScriptBin "renix" ''
  source ${flakeDir}/scripts/renix.sh
''
