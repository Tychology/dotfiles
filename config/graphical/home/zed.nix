{
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: let
    version = "1.7.2";
  in  {
  home.sessionVariables = {
    LOCAL_NOTEBOOK_DEV = 1;

  };
  programs.zed-editor = {
    enable = true;
    # package = inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default;
    package = pkgs-unstable.zed-editor-fhs;

    extensions = [];
    userSettings = {
      hour_format = "hour24";
      vim_mode = true;
    };
  };
  home.packages = [
    pkgs.carapace # for nushell extension
  ];
}
