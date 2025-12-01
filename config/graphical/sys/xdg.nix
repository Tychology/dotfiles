{pkgs, ...}: {
  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    config = {
      common = {
        "org.freedesktop.impl.portal.FileChooser" = ["gtk" "hyprland"];
        default = ["hyprland" "gtk"];
      };
      hyprland = {
        "org.freedesktop.impl.portal.FileChooser" = ["gtk" "hyprland"];
        default = ["hyprland" "gtk"];
      };
    };
  };
}
