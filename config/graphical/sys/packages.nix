{
  pkgs,
  inputs,
  lib,
  flakeDir,
  pkgs-unstable,
  ...
}: let
  # albertWrapped = import ../../../packages/albertWrapped.nix {inherit pkgs;};
in {
  environment.sessionVariables = {
    XDG_DATA_DIRS = lib.mkForce "$XDG_DATA_DIRS:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}";
  };

  environment.systemPackages = with pkgs; [
    albert
    # albertWrapped
    xdotool
    distrobox
    ghostty

    libnotify
    v4l-utils
    wl-clipboard

    openfortivpn

    hyprpicker
    brightnessctl
    virt-viewer
    appimage-run
    networkmanagerapplet
    peazip
    yad
    swww
    grim
    slurp
    swaynotificationcenter
    imv
    mpv
    pavucontrol
    wine
  ];
  # ++ [pkgs-unstable.albert];
}
