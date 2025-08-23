{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.kodi-wayland pkgs.cage pkgs.sof-firmware];
  # Define the user to run Kodi
  users.extraUsers.kodi = {
    isNormalUser = true;
    # Add to necessary groups for video/audio access
    extraGroups = ["video" "audio"];
    password = ""; # optional: set something or lock password
  };
  services.getty.autologinUser = "kodi";

  environment.shellAliases = {
    k = "cage kodi-standalone";
    p = "wpctl set-profile 48 4";
  };
}
