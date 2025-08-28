{
  inputs = {
    # nixpkgs.url = "github:Tychology/nixpkgs/bash-hotfix";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # Required for making sure that Pi-hole continues running if the executing user has no active session.
    linger = {
      url = "github:mindsbackyard/linger-flake";
      inputs.flake-utils.follows = "flake-utils";
    };

    pihole = {
      # url = "github:mindsbackyard/pihole-flake";
      # url = "/home/jonas/repos/pihole-flake";
      url = "github:Tychology/pihole-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.linger.follows = "linger";
    };
    sopswarden = {
      url = "github:pfassina/sopswarden/unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    peerix = {
      url = "github:Tychology/peerix";
      # url = "/home/jonas/repos/peerix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "jonas";
    flakeDir = builtins.toString ./.;
    wallpaper = "cosmiccliffs.png";
    hosts = ["think" "desk" "wyse" "wsl"];
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts (
      host: let
        hostDir = flakeDir + "/hosts/" + host;
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit system inputs username host flakeDir hostDir wallpaper hosts;
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.nixos-wsl.nixosModules.wsl

            inputs.linger.nixosModules.${system}.default
            inputs.pihole.nixosModules.${system}.default
            inputs.sopswarden.nixosModules.default
            inputs.agenix.nixosModules.default
            inputs.peerix.nixosModules.peerix

            ./hosts/${host}/config.nix
            ({
              config,
              pkgs,
              ...
            }: {
              nixpkgs.overlays = import ./overlays;
              nixpkgs.config.allowUnfree = true;
              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                substituters = ["https://cache.nixos.org/"];
                trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
              };

              stylix.base16Scheme = builtins.fromJSON ''{"base00":"011d45","base01":"184684","base02":"805aa3","base03":"8fa0b0","base04":"c2b6ba","base05":"ffc5a7","base06":"f3d9c2","base07":"f7cfcd","base08":"b57cb1","base09":"4698d0","base0A":"7995a1","base0B":"8c918d","base0C":"9788c1","base0D":"9f8a9d","base0E":"c57e84","base0F":"dd6b9e"}'';
            })

            home-manager.nixosModules.home-manager
            ({config, ...}: {
              home-manager.extraSpecialArgs = {
                inherit username inputs host flakeDir hostDir wallpaper;
                variables = import ./hosts/${host}/home/variables.nix;
                stylixBase16 = config.stylix.base16Scheme;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home/home.nix;
            })
          ];
        }
    );
  };
}
