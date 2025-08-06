{pkgs, ...}: {
  pkgs = pkgs.devenv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
  environment.systemPackages = [pkgs.devenv];
}
