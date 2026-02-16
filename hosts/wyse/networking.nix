{
  host,
  options,
  ...
}: let
  ip_config = import ./ip_config.nix;
in {
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  networking = {
    networkmanager.enable = false;
    useNetworkd = true;
    nameservers = [ip_config.dns "9.9.9.9"];
    hostName = host;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];


    firewall.enable = true;
    # nftables.enable = true;
    # nat = {
    #   enable = true;
    #   externalInterface = "enp1s0";
    # };
    defaultGateway = {
      interface = "br0";
      address = ip_config.gateway;
      source = ip_config.ip;
    };

    bridges.br0.interfaces = ["enp1s0"];
    interfaces = {
      br0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = ip_config.ip;
            prefixLength = ip_config.prefix_length;
          }
        ];
      };
    };
  };
}
