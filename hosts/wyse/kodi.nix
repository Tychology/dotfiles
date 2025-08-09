{
  pkgs,
  lib,
  ...
}: let
  uid = 1001;
  suid = toString uid;
in {
  environment.systemPackages = [pkgs.kodi-wayland];
  # Define the user to run Kodi
  users.extraUsers.kodi = {
    isNormalUser = true;
    uid = uid;
    # Add to necessary groups for video/audio access
    extraGroups = ["video" "audio"];
    password = ""; # optional: set something or lock password
  };
  services.getty.autologinUser = "kodi";

  # Ensure Wayland compositor cage is enabled to run Kodi standalone
  services.cage = {
    enable = true;
    user = "kodi";
    program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
  };

  systemd.tmpfiles.rules = [
    "d /run/user/1001 0700 kodi video -"
  ];

  # Define a systemd service to control kodi with cage
  systemd.services.kodi-cage = {
    description = "Kodi standalone session in cage Wayland compositor";
    after = ["network.target"];
    wantedBy = lib.mkForce [];
    serviceConfig = {
      User = "kodi";
      Group = "video";
      RuntimeDirectory = "kodi";
      RuntimeDirectoryMode = "0700";
      Environment = ''
        XDG_SESSION_TYPE=wayland
        XDG_RUNTIME_DIR=/run/user/1001
      '';
      ExecStart = "${pkgs.cage}/bin/cage ${pkgs.kodi-wayland}/bin/kodi-standalone";
      # Restart = "on-failure";
      StandardOutput = "journal";
      StandardError = "journal+console";
    };
  };
}
