{...}: {
  fileSystems = {
    "/mnt/hdd" = {
      device = "/dev/sdb2";
      fsType = "ntfs";
      options = ["defaults"];
    };
    "/mnt/ssd" = {
      device = "/dev/sda1";
      fsType = "ntfs";
      options = ["defaults"];
    };
    "/mnt/windows" = {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs";
      options = ["defaults"];
    };
    "/mnt/steam" = {
      device = "/mnt/hdd/Steam";
      options = ["bind"];
    };
  };
}
