{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.kodi-wayland pkgs.cage];
  # Define the user to run Kodi
  users.extraUsers.kodi = {
    isNormalUser = true;
    uid = uid;
    # Add to necessary groups for video/audio access
    extraGroups = ["video" "audio"];
    password = ""; # optional: set something or lock password
  };
  services.getty.autologinUser = "kodi";

  environment.shellAliases.k = "cage kodi-standalone";

  # services.cage = {
  #   enable = true;
  #   user = "kodi";
  #   program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
  # };
}
