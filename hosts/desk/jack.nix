{...}: {
  services.jack = {
    jackd.enable = true;
    # alsa.enable = true;
    # loopback.enable = true;
  };
  security.rtkit.enable = true;
}
