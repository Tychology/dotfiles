{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman
    podman-tui # Terminal-based UI for managing Podman containers
    dive # Tool to inspect Docker image layers
  ];
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    my-container = {
      image = "nginx:latest"; # Specify container image
      autoStart = true; # Automatically start the container on boot
      ports = ["127.0.0.1:8080:80"]; # Map ports for container access
    };
  };
  users.groups.podman = {
    name = "podman";
  };

  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [pkgs.zsh]}"
  '';
}
