{...}: let
  ip_config = import ./ip_config.nix;
in {
  services.tailscale = {
    useRoutingFeatures = "both";
    extraUpFlags = ["--advertise-routes=${ip_config.subnet}" ];
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
