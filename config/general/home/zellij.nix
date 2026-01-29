{config, ...}: {
  stylix.targets.zellij.colors.enable = true;
  programs.zellij = {
    enable = true;
    # enableZshIntegration = true;
    settings = {
      # theme = "stylix";
    };
    themes = {
    };
  };
}
