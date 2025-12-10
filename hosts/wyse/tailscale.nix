{...}: {
  services.tailscale = {
    useRoutingFeatures = "both";
    extraUpFlags = ["--advertise-routes=192.168.178.0/24"];
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
