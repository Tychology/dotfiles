{flakeDir, ...}: {
  home.file.".config/wlogout/icons" = {
    source = ./wlogout;
    recursive = true;
  };
}
