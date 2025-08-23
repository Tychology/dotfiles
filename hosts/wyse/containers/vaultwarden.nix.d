{...}: let
  ip = "192.168.178.12";
in {
  containers.vaultwarden = {
    autoStart = true; # Start container automatically on host boot
    privateNetwork = true; # Use a private network namespace for isolation
    hostAddress = ip; # Address on the container host side (optional)

    # Bind mount host directory for Vaultwarden data persistence
    bindMounts = {
      "/var/lib/vaultwarden" = {
        hostPath = "/srv/vaultwarden"; # Path on host where data is stored
        isReadOnly = false; # Writable inside container
      };
    };

    # The container's NixOS configuration
    config = {
      config,
      pkgs,
      ...
    }: {
      # Enable Vaultwarden service inside the container
      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://vaultwarden.example.com";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "0.0.0.0"; # Listen on all container interfaces
          ROCKET_PORT = 8080;
        };
        backupDir = "/var/lib/vaultwarden/backup";
      };

      # Enable the resolver service inside the container for DNS resolution
      services.resolved.enable = true;
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
      allowedTCPPorts = [80];
    };

    nftables.tables.vaultwarden = {
      name = "vaultwarden";
      family = "ip";
      content = ''
        chain PREROUTING {
          type nat hook prerouting priority dstnat; policy accept;
          ip daddr ${ip} tcp dport 80 dnat to ${ip}:8080
        }
      '';
    };
  };
}
