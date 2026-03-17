{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    #tuis
    discordo
    lynx
    bluetui
    impala
    wiremix
    
    
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    ladybird
    ungoogled-chromium


    # creation
    musescore
    obs-studio
    onlyoffice-desktopeditors
    libreoffice
    inkscape
    krita
    blender
    godot
    freecad-wayland
    # inputs.affinity-nix.packages."${pkgs.stdenv.hostPlatform.system}".v3

    pdftk
    obsidian
    wl-mirror
    kdePackages.okular
    bitwarden-desktop
    github-desktop
    xournalpp
    vesktop
    # discord-canary
    qdirstat
    qbittorrent-enhanced
    vial
    arduino-ide
    ausweisapp
    zoom-us
    cutter
    gource
    vscodium-fhs
    thunderbird
    wireshark
    teams-for-linux
    zotero
    android-tools
    heimdall
    wlsunset

    # jetbrains.idea-ultimate
    # jetbrains.rust-rover
    # jetbrains.pycharm-professional
    # jetbrains-toolbox
  ];
}
