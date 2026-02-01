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
    
    
    inputs.zen-browser.packages."${system}".default
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

    # jetbrains.idea-ultimate
    # jetbrains.rust-rover
    # jetbrains.pycharm-professional
    # jetbrains-toolbox
  ];
}
