{...}: {
  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };
}
