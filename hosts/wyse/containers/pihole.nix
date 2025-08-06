{pkgs, ...}: {
  services.pihole.enable = true;

  services.pihole.hostConfig = {
    user = "pihole"; # Define the user that will run the container
    enableLingeringForUser = true;
    suppressTmpDirWarning = true;
    persistVolumes = true;
    volumesPath = "/var/lib/pihole";

    # Expose ports.  Adjust as needed, especially for rootless.
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "67:67/udp" # Only if you use Pi-hole's DHCP server
      "8003:8003"
    ];
  };

  services.pihole.piholeConfig = {
    PIHOLE_DNS_ = "1.1.1.1;1.0.0.1"; # Example DNS servers
    WEBPASSWORD = "12345";
  };

  # Create the user to run the container
  users.users.pihole = {
    isSystemUser = true;
    group = "pihole";
  };

  users.groups.pihole = {};

  # Firewall configuration
  networking.firewall.allowedTCPPorts = [53 8003];
  networking.firewall.allowedUDPPorts = [53 67];

  systemd.user.services.podman-my-pihole = {
    Unit = {
      Description = "Pihole Podman container";
      After = ["network.target"];
      Requires = ["network.target"];
    };

    Service = {
      Restart = "on-failure";
      ExecStart = "${pkgs.podman}/bin/podman start pihole";
      ExecStop = "${pkgs.podman}/bin/podman stop pihole";
    };
    Install = {
      WantedBy = ["multi-user.target"];
    };
  };
}
