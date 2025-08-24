{...}: {
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashntegration = true;
    enableZshIntegration = true;
  };
}
