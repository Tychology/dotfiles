{username, ...}: {
  programs.nh = {
    enable = true;
    # flake = /home/${username}/dotfiles;
  };
  environment.variables = {NH_FLAKE = "/home/${username}/dotfiles";};
}
