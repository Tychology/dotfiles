{
  username,
  config,
  ...
}: let
  ip = "192.168.178.11";
  dnsPort = 5311;
  dnsPortStr = toString dnsPort;
  webPort = 8011;
  webPortStr = toString webPort;
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
      dnsPort = dnsPort;
      webPort = webPort;
    };
    piholeConfig = {
      tz = "Europe/Berlin";
      interface = "enp1s0";
      ftl = {
        # assuming that the host has this (fixed) IP and should resolve "pi.hole" to this address
        # check the option description & the FTLDNS documentation for more information
        FTLCONF_DELAY_STARTUP = "5";
        LOCAL_IPV4 = ip;
      };
      web = {
        virtualHost = "pi.hole";
        # password = config.sops.secrets.pihole.path;
        # password = "password";
        passwordFile = "/home/pihole/password";
      };
      dns = {
        upstreamServers = ["9.9.9.9" "149.112.112.112" "1.1.1.1" "1.0.0.1"];
      };
    };
  };

  networking = {
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = ip;
        prefixLength = 24;
      }
    ];

    firewall = {
      allowedTCPPorts = [53 dnsPort 80 webPort];
      allowedUDPPorts = [53 dnsPort];
    };

    nftables.tables.pihole = {
      enable = true;
      name = "pihole";
      family = "ip";
      content = ''
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          ip daddr ${ip} tcp dport 80 counter dnat to ${ip}:${webPortStr}
          ip daddr ${ip} tcp dport 53 counter dnat to ${ip}:${dnsPortStr}
          ip daddr ${ip} udp dport 53 counter dnat to ${ip}:${dnsPortStr}
        }
        chain OUTPUT {
          type nat hook output priority mangle; policy accept;
          ip daddr ${ip} tcp dport 80 counter dnat to ${ip}:${webPortStr}
          ip daddr ${ip} tcp dport 53 counter dnat to ${ip}:${dnsPortStr}
          ip daddr ${ip} udp dport 53 counter dnat to ${ip}:${dnsPortStr}
        }
        chain postrouting {
          type nat hook postrouting priority srcnat; policy accept;
          ip saddr 192.168.178.0/24 oifname "enp1s0" counter masquerade
        }

      '';
    };
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
