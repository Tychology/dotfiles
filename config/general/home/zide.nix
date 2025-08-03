{username, ...}: {
  home = {
    file.".config/zide" = {
      source = ./zide;
      recursive = true;
    };

    sessionVariables.ZIDE_DIR = "/home/${username}/.config/zide";
    sessionPath = ["/home/${username}/.config/zide/bin"];
  };
}
