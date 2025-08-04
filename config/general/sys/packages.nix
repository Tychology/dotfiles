{pkgs, ...}: let
in {
  environment.systemPackages = with pkgs; [
    man-pages
    uutils-coreutils-noprefix
    fd
    ripgrep
    fzf
    eza
    bat
    nushell
    fish
    gcc
    xh
    dua
    direnv
    devenv
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
    img2pdf

    lshw
    pkg-config
    nh
    libvirt
    mtr

    alejandra
    nixd
    nil
    clang-tools
    marksman
    lua-language-server
    jdt-language-server
    openfortivpn
  ];
}
