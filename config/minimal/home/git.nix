{variables, ...}: let
  # inherit "../../../hosts/${host}/home/variarles.nix" gitUsername gitEmail;
in {
  programs.git = {
    enable = true;
    settings = {
      user.name = "${variables.gitUsername}";
      user.email = "${variables.gitEmail}";
      init.defaultBranch = "main";
      credential.helper = "store --file ~/.git_credentials";
    };
  };

}
