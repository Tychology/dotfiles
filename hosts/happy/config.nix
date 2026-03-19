{
  flakeDir,
  lib,
  username,
  ...
}: {
  imports =
    [
      (import ./default.nix)
    ]
    ++ (map (p: (flakeDir + p)) [
      "/config/minimal/sys"
    ]);

  # Set your time zone.
  time.timeZone = lib.mkForce "Europe/Berlin";

  services = {
    smartd.enable = lib.mkForce false;
    keyd.enable = lib.mkForce false;
  };
  programs = {
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };


  services.openssh.enable = true;

  users.users."${username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJstTlmiUvM9qZ0/WIW4sNb76dN+QWuubcVKIaw2imxM"
  ];

  nix.extraOptions = ''
    trusted-users = root jonas
  '';

  users = {
    mutableUsers = true;
  };

  environment.variables = {
    # NH_FLAKE = "~/dotfiles";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
