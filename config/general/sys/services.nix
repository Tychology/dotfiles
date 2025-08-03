{...}: {
  services = {
    automatic-timezoned.enable = true;
    smartd = {
      enable = true;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
    ipp-usb.enable = true;
  };
}
