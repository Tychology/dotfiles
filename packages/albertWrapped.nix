{pkgs ? import <nixpkgs> {}}: let
  # List of additional dependencies Albert might need
  additionalDeps = with pkgs; [
    gsettings-desktop-schemas
    glib
    gtk3
    qt5.qtbase
    qt5.qtsvg
    libsForQt5.qtstyleplugins
  ];
in
  pkgs.symlinkJoin {
    name = "albert-wrapped";
    paths = [pkgs.albert] ++ additionalDeps;
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/albert \
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share:${pkgs.gtk3}/share" \
        --prefix GSETTINGS_SCHEMA_DIR : "${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas" \
        --prefix QT_PLUGIN_PATH : "${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}" \
        --prefix QT_QPA_PLATFORM_PLUGIN_PATH : "${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}/platforms" \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath additionalDeps}"
    '';
  }
