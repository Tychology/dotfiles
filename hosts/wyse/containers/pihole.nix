{
  username,
  config,
  ...
}: let
  ip_config = import ../ip_config.nix;
  id = 1;
  ip = ip_config.container_prefix ++ toString id;
  dnsPort = 5300 + id;
  dnsPortStr = toString dnsPort;
  webPort = 8000 + id;
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
          ip saddr ${ip_config.subnet} oifname "enp1s0" counter masquerade
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
        startUid = 100000 * id + 1;
        count = 65534;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000 * id + 1;
        count = 65534;
      }
    ];
  };

  users.groups.pihole = {};
}
