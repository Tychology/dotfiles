{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [youtube]))
    kodi-wayland
    cage
    sof-firmware
  ];
  # Define the user to run Kodi
  users.extraUsers.kodi = {
    isNormalUser = true;
    # Add to necessary groups for video/audio access
    extraGroups = ["video" "audio"];
    password = ""; # optional: set something or lock password
  };
  services.getty.autologinUser = "kodi";

  networking.firewall.allowedTCPPorts = [
    50152
  ];
  environment.shellAliases = {
    k = "cage kodi-standalone";
    p = "wpctl set-profile 48 4";
  };
}
