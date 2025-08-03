{
  host,
  options,
  ...
}: {
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  networking = {
    interfaces.wlp4s0 = {
      ipv6.addresses = [
        {
          address = "2a02:908:1a3:4ca0::2"; # Replace with your static IPv6 address
          prefixLength = 56; # Replace with your network's prefix length
        }
      ];
    };
  };
}
