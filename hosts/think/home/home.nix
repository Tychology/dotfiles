{
  username,
  flakeDir,
  ...
}: {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports =
    [
      ./default.nix
    ]
    ++ (map (p: import (flakeDir + p)) [
      "/config/general/home"
      "/config/graphical/home"
      "/scripts"
    ]);
}
