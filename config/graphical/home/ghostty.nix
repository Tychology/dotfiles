{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      background-blur-radius = 20;
    };
  };
}
