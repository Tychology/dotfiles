{pkgs, ...}: {
  programs.rbw = {
    enable = true;
    settings = {
      email = "xyjojoyx@gmail.com";
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-tty;
    };
  };
}
