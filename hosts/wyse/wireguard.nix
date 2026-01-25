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

  networking.wireguard.interfaces.wg0 = {
    ips = ["192.168.178.204/24"];
    privateKeyFile = config.age.secrets.wg-private.path;

    peers = [
      {
        publicKey = "zyrkF+fyUlMeNycfJmKcRU8yo8jAgeRdm4Q16pRwQVQ=";
        endpoint = "h98z34vtiojmm.duckdns.org:12408";
        presharedKeyFile = config.age.secrets.wg-f-preshared.path;
        allowedIPs = ["192.168.178.0/24" "0.0.0.0/0" "::/0"];
        persistentKeepalive = 25;
      }
    ];
  };
}
