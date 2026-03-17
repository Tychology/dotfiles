{
  username,
  flakeDir,
  ...
}: {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  # Import Program Configurations
  imports =
    [
      ./default.nix
    ]
    ++ (map (p: import (flakeDir + p)) [
      "/config/minimal/home"
      # "/scripts"
    ]);
}
