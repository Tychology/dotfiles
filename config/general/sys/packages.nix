{pkgs, ...}: let
in {
  environment.systemPackages = with pkgs; [
    fish
    valgrind
    lldb
    gdb
    ffmpeg
    imagemagick
    openfortivpn
    alsa-utils
    html-tidy
    agenix-cli
    
    python3
    uv
    nixpkgs-pytools   
     
    pkg-config
    libvirt
  ];
}
