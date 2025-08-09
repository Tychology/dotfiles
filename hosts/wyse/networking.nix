{
  host,
  options,
  ...
}: {
  networking = {
    networkmanager.enable = true;
    nameservers = ["192.168.178.1"];
    hostName = host;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];

    firewall.enable = true;
    nftables.enable = true;
    nat = {
      enable = true;
      externalInterface = "enp1s0";
    };
    defaultGateway = "192.168.178.1";
    interfaces = {
      enp1s0 = {
        ipv4.addresses = [
          {
            address = "192.168.178.10";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
