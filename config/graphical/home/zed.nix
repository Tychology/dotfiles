{pkgs,...}: {
programs.zed-editor = {
  enable = true;
  package = pkgs.zed-editor-fhs;
  extensions = [  ];
  userSettings = {
    hour_format = "hour24";
    vim_mode = true;
  };
};
home.packages = [
  pkgs.carapace # for nushell extension
];
}
