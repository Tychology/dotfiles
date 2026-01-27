{
  host,
  options,
  ...
}: let ip_config = import ./ip_config.nix{
  networking = {
    networkmanager.enable = false;
    useNetworkd = true;
    nameservers = [ip_config.dns];
    hostName = host;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];

    firewall.enable = true;
    nftables.enable = true;
    nat = {
      enable = true;
      externalInterface = "enp1s0";
    };
    defaultGateway = {
      interface = "enp1s0";
      address = ip_config.gateway;
    };
    interfaces = {
      enp1s0 = {
        ipv4.addresses = [
          {
            address = ip_config.container_prefix ++ "0";
            prefixLength = 16;
          }
        ];
      };
    };
  };
}
