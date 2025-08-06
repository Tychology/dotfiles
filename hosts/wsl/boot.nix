{
  pkgs,
  config,
  ...
}: {
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = ["v4l2loopback" "uinput"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.grub.enable = false;
    plymouth.enable = true;
  };
}
