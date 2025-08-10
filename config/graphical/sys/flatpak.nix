{pkgs, ...}: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.valvesoftware.Steam"
      "com.usebottles.bottles"
      "net.lutris.Lutris"
      "dev.vieb.Vieb"
      "org.prismlauncher.PrismLauncher"
    ];
  };
  systemd.services.flatpak-repo = {
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
