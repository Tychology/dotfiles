{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.kodi.enableAdvancedLauncher = true;
  environment.systemPackages = with pkgs; [
    # (kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [youtube inputstream-adaptive inputstream-ffmpegdirect]))
    (kodi.withPackages (kodiPkgs: with kodiPkgs; [youtube inputstream-adaptive inputstream-ffmpegdirect]))

    kodiPackages.inputstream-adaptive
    kodiPackages.youtube
    cage
    sof-firmware
    tcpdump
    # xorg.xinit
  ];
  services.seatd.enable = true;
  # services.xserver = {
  #   enable = true;
  #   displayManager.startx.enable = true;
  #   desktopManager.kodi.enable = true;
  #   resolutions = [
  #     {
  #       x = 1920;
  #       y = 1080;
  #     }
  #   ];
  # };

  # Define the user to run Kodi
  users.extraUsers.kodi = {
    isNormalUser = true;
    # Add to necessary groups for video/audio access
    extraGroups = ["video" "audio"];
    password = ""; # optional: set something or lock password
  };
  services.getty.autologinUser = "kodi";
  networking.firewall.allowedTCPPorts = [
    9777 # Event Server
    8010 # kodi http control
    50152 # for youtube addon api
  ];
  networking.firewall.allowedUDPPorts = [
    5610 # Wake on lan
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

  systemd.user.services.xbmcstarter = {
    enable = true;
    description = "Yatse XBMC starter listener service";
    after = ["network.target"];
    wantedBy = ["default.target"];
    unitConfig.ConditionUser = "kodi";

    # Make sure sudo and tcpdump are available in PATH
    path = with pkgs; [
      bash
      netcat
      kodi
      cage

      nushell
    ];

    serviceConfig = let
      execStart = pkgs.writers.writeNu "xbmcstarter-ExecStart" ''
        let port = 5610
        let trigger_message = "D'"

        print "xbmcstarter listening on UDP port 5610"

          nc -6luk 5610 | each {|msg|
           let msg_type = ($msg | describe)

           let text = if $msg_type == "binary" {
             $msg | decode utf-8 | str trim
            } else {
              $msg | str trim
            }


            if ($text | str contains $trigger_message) {
              print "Trigger received — starting Kodi"
              cage kodi-standalone
            } else {
              print $"Ignored packet: ($text)"
          }
        }
      '';
    in {
      # Environment = "XDG_RUNTIME_DIR=/run/user/$(id -u kodi)";
      Type = "simple";
      ExecStart = "${pkgs.coreutils}/bin/stdbuf -oL -eL ${execStart}";
      Restart = "always";
      StandardOutput = "journal";
      StandardError = "journal";

      # User = "kodi";
      # Group = "kodi";
    };
  };

  system.activationScripts.syncInputStreamAdaptive = let
    inputstreamPath = pkgs.kodiPackages.inputstream-adaptive.outPath;
  in {
    text = ''
      #!/bin/sh
      TARGET="/home/kodi/.kodi/addons/inputstream.adaptive"
      STORE_PATH="${inputstreamPath}/share/kodi/addons/inputstream.adaptive"

      # Remove old link if exists
      rm -rf "$TARGET"

      # Create new symbolic link
      ln -s "$STORE_PATH" "$TARGET"
    '';
  };
}
