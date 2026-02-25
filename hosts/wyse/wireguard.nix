{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
  age.secrets = {
    wg-private = {
      file = ./secrets/wg-private.age;
      owner = "root";
      mode = "600";
    };

    wg-f-preshared = {
      file = ./secrets/wg-f-preshared.age;
      owner = "root";
      mode = "600";
    };
  };

  networking.wireguard = {
    enable = true;
    useNetworkd = true;
    interfaces.wg0 = {
      ips = ["192.168.178.204/24"];
      privateKeyFile = config.age.secrets.wg-private.path;

      peers = [
        {
          publicKey = "zyrkF+fyUlMeNycfJmKcRU8yo8jAgeRdm4Q16pRwQVQ=";
          endpoint = "h98z34vtiojmm.duckdns.org:12408";
          presharedKeyFile = config.age.secrets.wg-f-preshared.path;
          allowedIPs = ["192.168.178.0/24"];
          persistentKeepalive = 5;
        }
      ];
    };
  };

  systemd = {
    services = {
      "wg-keepalive" = {
        enable = true;
        description = "WireGuard keepalive pinger";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.iputils}/bin/ping -I wg0 -n -i 5 192.168.178.1";
          Restart = "always";
          RestartSec = 5;
          User = "root";
        };
      };

      "wg-restart" = {
        enable = true;
        description = "Periodic WireGuard restart";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemctl restart systemd-networkd";
        };
      };
    };

    timers."wg-restart" = {
      enable = true;
      description = "Timer for periodic WireGuard restart";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 0/3:00:00";
        Unit = "wg-restart.service";
        Persistent = true;
      };
    };
  };
}
