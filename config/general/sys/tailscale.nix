{pkgs, ...}: {
  environment.systemPackages = [pkgs.tailscale];
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--accept-routes"];
  };
}
