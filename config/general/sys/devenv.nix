{pkgs-unstable, ...}: {
  # nixpkgs.config.packageOverrides = pkgs: {
  #   devenv = pkgs.devenv.overrideAttrs (oldAttrs: {
  #     doCheck = false;
  #   });
  # };
  environment.systemPackages = [pkgs-unstable.devenv];
}
