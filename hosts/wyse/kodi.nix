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
    8010 # kodi http control
    50152 # for youtube addon api
  ];
  #for TubeCast
  networking.interfaces.enp1s0.ipv4.routes = [
    {
      address = "239.255.255.250";
      prefixLength = 32;
    }
  ];
  environment.shellAliases = {
    k = "XKB_DEFAULT_LAYOUT='de' cage kodi-standalone";
  };
  # environment.sessionVariables.XKB_DEFAULT_LAYOUT = "de";
}
