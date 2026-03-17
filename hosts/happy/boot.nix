{
  pkgs,
  config,
  lib,
  ...
}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true; # Usually safe on VPS
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };
}
