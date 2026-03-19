{
  host,
  options,
  ...
}: {
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  networking = {
    defaultGateway.address = "77.90.40.1";
    firewall.enable = true;
    interfaces = {
      ens3 = {
        ipv4 = [
          {
            address = "77.90.40.30";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
