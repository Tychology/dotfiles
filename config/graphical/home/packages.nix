{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
    wl-mirror
    kdePackages.okular
    bitwarden
    github-desktop
    obsidian
    xournalpp
    vesktop
    discord-canary
    musescore
    obs-studio
    qdirstat
    qbittorrent-enhanced
    vial
    onlyoffice-bin_latest
    libreoffice
    arduino-ide
    inkscape
    krita
    ausweisapp
    zoom-us
    cutter
    gource
    vscodium-fhs
    kdePackages.kdeconnect-kde
    ladybird
    # vieb
    # nyxt
    thunderbird
    wireshark
    freecad-wayland
    teams-for-linux
    zotero
    android-tools
    heimdall

    # jetbrains.idea-ultimate
    jetbrains.rust-rover
    jetbrains.pycharm-professional
    jetbrains-toolbox
  ];
}
