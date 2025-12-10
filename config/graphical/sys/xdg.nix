{pkgs, ...}: {
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-termfilechooser
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
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
