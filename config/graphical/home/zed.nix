{pkgs,...}: {
programs.zed-editor = {
  enable = true;
  extensions = [ "nix" "toml" "rust" "python" ];
  userSettings = {
    hour_format = "hour24";
    vim_mode = true;
  };
};
home.packages = [
  pkgs.carapace # for nushell extension
];
}
