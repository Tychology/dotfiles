{pkgs, ...}: {
  environment.systemPackages = [pkgs.sof-firmware];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };
  # services.pulseaudio.enable = true;
  environment.etc."wireplumber/wireplumber.conf.d/99-alsa.conf".source = ./wireplumber-99-alsa.conf;
}
