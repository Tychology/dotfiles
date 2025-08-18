{
  hosts,
  pkgs,
  inputs,
  ...
}: {
  services.peerix = {
    enable = false;
    package = inputs.peerix.packages.${pkgs.system}.peerix;
    openFirewall = true; # UDP/12304

    # privateKeyFile = ../secrets/peerix-private;
    # publicKeyFile = ../secrets/peerix-public;

    user = "peerix";
    group = "peerix";

    disableBroadcast = true;
    extraHosts = hosts;
  };
  users.users.peerix = {
    isSystemUser = true;
    group = "peerix";
  };
  users.groups.peerix = {};
}
