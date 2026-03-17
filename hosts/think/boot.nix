{
  pkgs,
  config,
  ...
}: {
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_6_12;
    # This is for OBS Virtual Cam Support
    kernelModules = ["v4l2loopback" "wacom" "hid_wacom"];
    # blacklistedKernelModules = ["hid_generic"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    extraModprobeConfig = ''
      options wacom reset=1
    '';
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    plymouth.enable = true;
  };
}
