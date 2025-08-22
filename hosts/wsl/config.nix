{
  flakeDir,
  lib,
  ...
}: {
  imports =
    [
      (import ./default.nix)
    ]
    ++ (map (p: (flakeDir + p)) [
      "/config/general/sys"
      "/modules/intel-drivers.nix"
      "/modules/vm-guest-services.nix"
      "/modules/local-hardware-clock.nix"
    ]);

  # Extra Module Options
  drivers.intel.enable = true;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # Set your time zone.
  # time.timeZone = lib.mkForce "Europe/Berlin";

  wsl = {
    enable = true;
    defaultUser = "jonas";
  };
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
  system.stateVersion = "23.11"; # Did you read the comment?
}
