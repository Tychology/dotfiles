{...}: {
  boot.cleanTmpDir = true;

  # the Pi-hole service configuration
  services.pihole = {
    enable = true;
    hostConfig = {
      # define the service user for running the rootless Pi-hole container
      user = "pihole";
      enableLingeringForUser = true;
      containerName = "pihole";
      # we want to persist change to the Pi-hole configuration & logs across service restarts
      # check the option descriptions for more information
      persistVolumes = true;

      # expose DNS & the web interface on unpriviledged ports on all IP addresses of the host
      # check the option descriptions for more information
      dnsPort = 53;
      webProt = 8001;
    };
    piholeConfig = {
      ftl = {
        # assuming that the host has this (fixed) IP and should resolve "pi.hole" to this address
        # check the option description & the FTLDNS documentation for more information
        LOCAL_IPV4 = "192.168.178.2";
      };
      web = {
        virtualHost = "pi.hole";
        password = "password";
      };
      dns = {
        upstreamServers = ["9.9.9.9" "149.112.112.112" "1.1.1.1" "1.0.0.1"];
      };
    };
  };

  # we need to open the ports in the firewall to make the service accessible beyond `localhost`
  # assuming that Pi-hole is exposed on the host interface `eth0`
  networking.firewall.interfaces.enp1s0 = {
    allowedTCPPorts = [53 8001];
    allowedUDPPorts = [53];
  };

  # Create the user to run the container
  users.users.pihole = {
    isSystemUser = true;
    group = "pihole";
  };

  users.groups.pihole = {};
}
