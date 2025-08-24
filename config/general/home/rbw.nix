{pkgs, ...}: {
  programs.rbw = {
    enable = true;
    settings = {
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-curses;
    };
  };
}
