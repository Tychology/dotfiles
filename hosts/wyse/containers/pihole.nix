{username, ...}: let
  ip = "192.168.178.11";
in {
  boot.tmp.cleanOnBoot = true;

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
      volumesPath = "/home/pihole";

      # expose DNS & the web interface on unpriviledged ports on all IP addresses of the host
      # check the option descriptions for more information
      dnsPort = 5353;
      webPort = 8001;
    };
    piholeConfig = {
      tz = "Europe/Berlin";
      interface = "enp1s0";
      ftl = {
        # assuming that the host has this (fixed) IP and should resolve "pi.hole" to this address
        # check the option description & the FTLDNS documentation for more information
        FTLCONF_DELAY_STARTUP = "5";
        LOCAL_IPV4 = "192.168.178.10";
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

  networking = {
    # interfaces.enp1s0.ipv4.addresses = [
    #   {
    #     address = ip;
    #     prefixLength = 24;
    #   }
    # ];

    firewall = {
      allowedTCPPorts = [53 8001];
      allowedUDPPorts = [53];
    };
    nat.forwardPorts = [
      {
        sourcePort = 53;
        proto = "tcp";
        destination = "127.0.0.1:5353";
      }
      {
        sourcePort = 53;
        proto = "udp";
        destination = "127.0.0.1:5353";
      }
    ];
  };

  # Create the user to run the container
  users.users.pihole = {
    isNormalUser = true;
    createHome = true;
    group = "pihole";
    subUidRanges = [
      {
        startUid = 100001;
        count = 65534;
      }
    ];
    subGidRanges = [
      {
        startGid = 100001;
        count = 65534;
      }
    ];
  };

  users.groups.pihole = {};
}
