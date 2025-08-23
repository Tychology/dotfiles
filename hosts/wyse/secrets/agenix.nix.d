{
  inputs,
  system,
  ...
}: let
  # Get the list of files in the current directory
  files = builtins.readDir ./.;

  # Filter out `default.nix` and any non-Nix files
  ageFiles = builtins.filter (name: builtins.match ".*\\.age" name != null) (builtins.attrNames files);

  # Convert them into an attrset for age.secrets
  secretsAttrset = builtins.listToAttrs (map (fileName: {
      name = builtins.replaceStrings [".age"] [""] fileName; # remove extension
      value = {
        file = ./. + "/${fileName}"; # store the file path
      };
    })
    ageFiles);
in {
  environment.systemPackages = [inputs.agenix.packages.${system}.default];
  age.secrets = secretsAttrset;
}
