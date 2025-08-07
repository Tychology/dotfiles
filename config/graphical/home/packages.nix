{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
    wl-mirror
    bottles
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
    ausweisapp
    zoom-us
    lutris
    cutter
    prismlauncher
    gource
    vscodium-fhs
    kdePackages.kdeconnect-kde
    ladybird
    vieb
    # nyxt
    thunderbird

    jetbrains.idea-ultimate
    jetbrains.rust-rover
    jetbrains.pycharm-professional
    jetbrains-toolbox

    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic; # or another scheme as needed
      inherit (pkgs.texlive) xcolor; # explicitly include xcolor
      inherit (pkgs.texlive) framed;
      inherit (pkgs.texlive) fancyvrb;
      inherit (pkgs.texlive) etoolbox;
    })
  ];
}
