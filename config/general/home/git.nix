{variables, ...}: let
  # inherit "../../../hosts/${host}/home/variarles.nix" gitUsername gitEmail;
in {
  programs.git = {
    enable = true;
    userName = "${variables.gitUsername}";
    userEmail = "${variables.gitEmail}";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store --file ~/.git_credentials";
    };
  };
}
