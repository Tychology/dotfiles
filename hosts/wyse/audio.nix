{pkgs, ...}: {
  environment.systemPackages = [pkgs.sof-firmware];

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "monitor.alsa.rules" = {
          rules = [
            {
              matches = [
                {
                  "device.name" = "alsa_card.pci-0000_00_0e.0";
                }
              ];
              actions = {
                "update-props" = {
                  "device.profile" = "output:hdmi-stereo";
                  "priority.driver" = 3000;
                  "device.disabled" = false;
                };
              };
            }
          ];
        };
      };
    };
  };
}
