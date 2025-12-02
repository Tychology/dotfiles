{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-termfilechooser
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-termfilechooser
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    config = {
      common = {
        "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        default = ["hyprland" "gtk"];
      };
    };
  };
}
