{...}: let
  # Get the list of files in the current directory
  files = builtins.readDir ./.;

  # Filter out `default.nix` and any non-Nix files
  nixFiles = builtins.filter (name: name != "default.nix" && name != "config.nix" && name != "variables.nix" && builtins.match ".*\\.nix" name != null) (builtins.attrNames files);
in {
  imports = builtins.map (file: ./. + "/${file}") nixFiles;
}
