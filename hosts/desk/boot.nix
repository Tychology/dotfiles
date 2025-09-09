{
  pkgs,
  config,
  ...
}: {
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    plymouth.enable = true;

    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = true;
      default = "saved";
      efiSupport = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
    };

    # loader.systemd-boot = {
    #   enable = true;
    #   default = "@saved";
    #   extraEntries = {
    #     "windows.conf" = ''
    #       title Windows 11
    #       efi /EFI/Microsoft/Boot/bootmgfw.efi
    #       sort-key 0
    #     '';
    #   };
    # };
  };
}
