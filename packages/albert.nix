{pkgs ? import <nixpkgs> {}}: let
  albert = pkgs.albert.overrideAttrs (oldAttrs: {
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [])
      ++ [
        pkgs.wrapGAppsHook
        pkgs.makeWrapper
      ];

    buildInputs =
      (oldAttrs.buildInputs or [])
      ++ [
        pkgs.gsettings-desktop-schemas
        pkgs.glib
      ];

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share"
        --prefix GSETTINGS_SCHEMA_DIR : "${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas"
      )
    '';
  });
in
  albert
