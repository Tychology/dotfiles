{config, ...}: let
  name = "pihole";
  id = 1;
  idStr = toString id;
  ip_config = import ../ip_config.nix;

  ip = ip_config.dns;
  nameservers = ["9.9.9.9" "149.112.112.112" "1.1.1.1" "1.0.0.1"];
in {

  containers."${name}" = {
    autoStart = true;
    privateUsers = "no";

    localAddress = "${ip}/${toString ip_config.prefix_length}";
    privateNetwork = true;
    hostBridge = "br0";

    bindMounts = {
      "/var/lib/pihole" = {
        hostPath = "/home/${name}/state";
        isReadOnly = false;
      };
      "/var/log/pihole" = {
        hostPath = "/home/${name}/logs";
        isReadOnly = false;
      };
      "/etc/pihole" = {
        hostPath = "/home/${name}/settings";
        isReadOnly = false;
      };
    };

    config = {
      config,
      pkgs,
      ...
    }: {
      environment.systemPackages = [pkgs.lsof];
      networking = {
        useNetworkd = true;
        useHostResolvConf = false;
        nameservers = nameservers;
        interfaces = {
          eth0 = {
            ipv4.addresses = [
              {
                address = ip;
                prefixLength = ip_config.prefix_length;
              }
            ];
          };
        };

        defaultGateway = {
          address = ip_config.ip;
          interface = "eth0";
        };
      };

      systemd.tmpfiles.rules = [
        # Type Path Mode User Group Age Argument
        "f /etc/pihole/versions 0644 pihole pihole - -"
      ];

      services = {
        resolved = {
          enable = true;
          extraConfig = ''
            DNSStubListener=no
            MulticastDNS=off
          '';
        };

        pihole-ftl = {
          enable = true;
          openFirewallDNS = true;
          openFirewallDHCP = true;
          openFirewallWebserver = true;
          queryLogDeleter.enable = true;

          lists = [
            # {
            #   url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
            #   type = "block";
            #   enabled = true;
            #   description = "Steven Black's HOSTS";
            # }
          ];

          settings = {
            misc.readOnly = false;
            dns = {
              upstreams = nameservers;
            };
            ntp = {
              ipv4.active = false;
              ipv6.active = false;
              sync.active = false;
            };
            webserver = {
              api = {
                pwhash = "$BALLOON-SHA256$v=1$s=1024,t=32$NBUIadkim0RPsN00ZPIRPg==$JsOC/jFszzgjh1Vf4bWh9PrnGB4TA5ypEpi63wOjYEs=";
              };
              session = {
                timeout = 43200;
              };
            };
          };
        };

        pihole-web = {
          enable = true;
          ports = [80];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 53];
  networking.firewall.allowedUDPPorts = [53];

  users.users.pihole = {
    isNormalUser = true;
    createHome = true;
    group = "pihole";
  };
  users.groups.pihole = {};
}
