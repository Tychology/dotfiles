{config, ...}: let
  name = "webdav";
  id = 2;
  idStr = toString id;
  ip_config = import ../ip_config.nix;

  ip = "${ip_config.container_prefix}.${idStr}";

  webPort = 8000 + id;
  mountPoint = "/var/lib/webdav";
  srvPath = "${mountPoint}/srv";
  containerData = "/var/lib/containers/${name}";
  hostUser = "${name}_host";
in {
  age.secrets = {
    webdav-env = {
      file = ../secrets/webdav-env.age;
      owner = "root";
      mode = "600";
    };
  };

  containers.webdav = {
    autoStart = true;

    localAddress = ip;
    privateNetwork = true;
    hostBridge = "br0";

    bindMounts = {
      "${mountPoint}" = {
        hostPath = containerData;
        isReadOnly = false;
      };
      "/etc/webdav/.env" = {
        hostPath = config.age.secrets.webdav-env.path;
        isReadOnly = true;
      };
    };

    config = {
      config,
      pkgs,
      ...
    }: {
      environment.systemPackages = [pkgs.webdav];
      services.webdav = {
        enable = true;
        environmentFile = /etc/webdav/.env;
        user = "webdav";
        group = "webdav";

        settings = {
          address = "0.0.0.0";
          port = webPort;
          directory = "${srvPath}";
          permissions = "none";
          debug = true;

          users = [
            {
              username = "{env}ENV_USERNAME_J";
              password = "{env}ENV_PASSWORD_J";
              directory = "${srvPath}/j";
              permissions = "CRUD";
            }

            {
              username = "{env}ENV_USERNAME_K";
              password = "{env}ENV_PASSWORD_K";
              directory = "${srvPath}/k";
              permissions = "CRUD";
            }
          ];

          # cors = {
          #   enabled = true;
          #   credentials = true;
          #   allowedMethods = [
          #     "COPY"
          #     "DELETE"
          #     "GET"
          #     "HEAD"
          #     "LOCK"
          #     "UNLOCK"
          #     "MKCOL"
          #     "MOVE"
          #     "OPTIONS"
          #     "POST"
          #     "PROPFIND"
          #     "PROPPATCH"
          #     "PUT"
          #   ];
          # };
        };
      };

      systemd.services.webdav.serviceConfig = {
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = ["AF_INET" "AF_UNIX"];
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ReadWritePaths = ["${srvPath}"];
      };

      systemd.tmpfiles.rules = [
        "d ${mountPoint} 0755 root root - -"
        "d ${srvPath} 0755 webdav webdav - -"
        "d ${srvPath}/j 0755 webdav webdav - -"
        "d ${srvPath}/k 0755 webdav webdav - -"
        "Z ${mountPoint} 0755 webdav webdav - -"
        "Z ${srvPath} 0755 webdav webdav - -"
      ];

      users.users.webdav = {
        isSystemUser = true;
        group = "webdav";
      };

      users.groups.webdav = {};

      networking = {
        firewall = {
          allowedTCPPorts = [webPort];
        };
        useNetworkd = true;
        useHostResolvConf = false;
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
    };
  };

  networking.firewall = {
    allowedTCPPorts = [webPort];
    interfaces.br0.allowedTCPPorts = [webPort];
  };

  users.users."${hostUser}" = {
    isNormalUser = true;
    createHome = true;
    group = "${hostUser}";
  };
  users.groups."${hostUser}" = {};

  
      systemd.tmpfiles.rules = [
        "d ${containerData} 0755 root root - -"
      ];


}
