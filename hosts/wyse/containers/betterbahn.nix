{...}: let
  name = "betterbahn";
  id = 12;
  idStr = toString id;
  ip = "192.168.178.${idStr}";
  webPort = 8012;
  webPortStr = toString webPort;
in {
  virtualisation.oci-containers.containers."${name}" = {
    image = "ghcr.io/l2xu/betterbahn:latest";
    ports = ["${webPortStr}:3000"];
    podman.user = name;
  };
  networking = {
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = ip;
        prefixLength = 24;
      }
    ];

    firewall = {
      allowedTCPPorts = [80 webPort];
    };

    nftables.tables."${name}" = {
      enable = true;
      name = name;
      family = "ip";
      content = ''
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          ip daddr ${ip} tcp dport 80 counter dnat to ${ip}:${webPortStr}
        }

        chain postrouting {
          type nat hook postrouting priority srcnat; policy accept;
          ip saddr 192.168.178.0/24 oifname "enp1s0" counter masquerade
        }
      '';
    };
  };

  # Create the user to run the container
  users.users."${name}" = {
    isNormalUser = true;
    createHome = true;
    group = name;
    subUidRanges = [
      {
        startUid = id * 100000 + 1;
        count = 65534;
      }
    ];
    subGidRanges = [
      {
        startGid = id * 100000 + 1;
        count = 65534;
      }
    ];
  };

  users.groups."${name}" = {};
}
