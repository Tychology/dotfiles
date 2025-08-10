{pkgs, ...}: {
  boot.kernelModules = ["i915"];
  boot.kernelParams = ["i915.enable_guc=2"]; # or 3 depending on firmware
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [mesa];
}
