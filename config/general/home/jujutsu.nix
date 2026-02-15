{variables, pkgs-unstable, ...}: {
  programs = {
    jujutsu = {
      enable = true;
      package = pkgs-unstable.jujutsu;
      settings = {
        user = {
          email = variables.gitEmail;
          name = variables.gitUsername;
        };
      };
    };
    jjui = {
      enable = true;
    };
  };
}
