{
  config,
  pkgs,
  ...
}: let
  name = "exosphere";
  user = "minecraft";
  dataPath = "/home/${user}/${name}/data";
  downloadPath = "/home/${user}/Downloads";
  runtimeDir = "/run/user/${toString config.users.users."${user}".uid}";
in {
  systemd.services."podman-${name}" = {
    description = "Podman container ${name}";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    path = [config.virtualisation.podman.package "/run/current-system/sw/bin"];
    serviceConfig = {
      User = user;
      ExecStartPre = ''
        ${pkgs.podman}/bin/podman rm -f ${name} || true \
        rm -f ${runtimeDir}/${name}-ctr-id
        # mkdir -p ${dataPath} && \
        # chown -R ${user} ${dataPath}

      '';
      ExecStart = ''
        ${pkgs.podman}/bin/podman run --name ${name} \
          -p 25565:25565 \
          -v /home/${user}/${name}/data:/data \
          -v /home/${user}/Downloads:/downloads \
          -e EULA=TRUE \
          -e TYPE=AUTO_CURSEFORGE \
          -e MEMORY=4G \
          -e DIFFICULTY=EASY \
          -e CF_SLUG=bm-exosphere \
          --env-file /home/${user}/.env \
          --cidfile=${runtimeDir}/${name}-ctr-id \
          --userns=keep-id \
          -d \
          itzg/minecraft-server
      '';
      ExecStop = "${pkgs.podman}/bin/podman stop ${name}";
      Restart = "no";
      # RuntimeDirectory = runtimeDir;
    };
    wantedBy = ["multi-user.target"];
  };

  networking.firewall.allowedTCPPorts = [25565];

  services.linger = {
    enable = true;
    users = [user];
  };

  users.users."${user}" = {
    uid = 1002;
    isNormalUser = true;
    group = user;
    initialPassword = "1234";
    createHome = true;
    subUidRanges = [
      {
        startUid = 1100001;
        count = 65534;
      }
    ];
    subGidRanges = [
      {
        startGid = 1100001;
        count = 65534;
      }
    ];
  };

  users.groups."${user}" = {};

  environment.sessionVariables."${name}" = "sudo -u ${user} systemctl --user restart podman-${name}";
}
