{pkgs-unstable,...}: {
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    virt-manager.enable = true;
    niri = {
      enable = true;
      package = pkgs-unstable.niri;
    };
    xwayland.enable = true;
  };
}
