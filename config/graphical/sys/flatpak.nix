{pkgs, ...}: {
  services.flatpak = {
    enable = true;
    packages = [
      "dev.vieb.Vieb"
    ];
  };
  systemd.services.flatpak-repo = {
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
