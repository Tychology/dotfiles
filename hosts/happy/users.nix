{
  pkgs,
  username,
  ...
}: let
  inherit (import ./home/variables.nix) gitUsername shell;
in {
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
      ];
      shell = pkgs.${shell};
      ignoreShellProgramCheck = true;
      packages = with pkgs; [
      ];
    };
  };
}
