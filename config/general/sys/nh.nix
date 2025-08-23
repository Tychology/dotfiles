{username, ...}: {
  programs.nh = {
    enable = true;
    # flake = /home/${username}/dotfiles;
  };
  environment.sessionVariables = {NH_FLAKE = "/home/${username}/dotfiles";};
}
