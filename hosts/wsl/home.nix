{
  pkgs,
  username,
  host,
  flakeDir,
  lib,
  ...
}: let
  inherit (import ./variables.nix) gitUsername gitEmail;
in {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../config/extra_home/direnv.nix
    ../../config/extra_home/helix.nix
    ../../config/extra_home/yazi.nix
    ../../config/extra_home/zoxide.nix
    ../../config/extra_home/zsh.nix
  ];

  # Place Files Inside Home Directory
  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Styling Options
  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.hyprland.enable = false;
  stylix.targets.hyprlock.enable = false;
  stylix.targets.qt.enable = false;

  # Scripts
  home.packages = [
    (import ../../scripts/renix.nix {
      inherit pkgs;
      inherit flakeDir;
    })
  ];

  services = {
  };
  programs = {
    starship = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
        eval "$(zoxide init bash)"
      '';
      shellAliases = {
        y = "yazi";
        x = "hx";
        cd = "z";

        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/zaneyos";
        fu = "nh os switch --hostname ${host} --update /home/${username}/zaneyos";
        zu = "sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/raw/main/install-zaneyos.sh)";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        ".." = "cd ..";
      };
    };
    home-manager.enable = true;
  };
}
