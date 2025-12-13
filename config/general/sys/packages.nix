{pkgs, ...}: let
in {
  environment.systemPackages = with pkgs; [
    man-pages
    uutils-coreutils-noprefix
    helix
    fd
    ripgrep
    fzf
    eza
    bat
    nushell
    fish
    yazi
    gcc
    xh
    dua
    duf
    direnv
    kmon
    bandwhich
    valgrind
    lldb
    gdb
    samba
    vim
    wget
    curl
    killall
    git
    htop
    btop
    unzip
    unrar
    ffmpeg
    imagemagick
    dnslookup
    openfortivpn
    alsa-utils
    nmap
    shadow

    python3
    uv
    nixpkgs-pytools   
     
    lshw
    pkg-config
    libvirt
  ];
}
