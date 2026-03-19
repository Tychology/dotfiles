{
  inputs = {
    # nixpkgs.url = "github:Tychology/nixpkgs/bash-hotfix";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # # Required for making sure that Pi-hole continues running if the executing user has no active session.
    # linger = {
    #   url = "github:mindsbackyard/linger-flake";
    #   inputs.flake-utils.follows = "flake-utils";
    # };

    # pihole = {
    #   # url = "github:mindsbackyard/pihole-flake";
    #   # url = "/home/jonas/repos/pihole-flake";
    #   url = "github:Tychology/pihole-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.linger.follows = "linger";
    # };
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "jonas";
    flakeDir = builtins.toString ./.;
    wallpaper = "cosmiccliffs.png";
    hosts = ["think" "desk" "wyse" "wsl" "happy"];

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts (
      host: let
        hostDir = flakeDir + "/hosts/" + host;
        overlays = import ./overlays;
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit system inputs username host flakeDir hostDir wallpaper hosts pkgs-unstable;
          };
          modules =
            (
              if host != "happy"
              then [
                inputs.niri.nixosModules.niri
                inputs.nixos-wsl.nixosModules.wsl
                inputs.nix-flatpak.nixosModules.nix-flatpak
                # inputs.linger.nixosModules.${system}.default
                # inputs.pihole.nixosModules.${system}.default
                inputs.stylix.nixosModules.stylix
              ]
              else []
            )
            ++ [
              inputs.nix-index-database.nixosModules.nix-index

              inputs.agenix.nixosModules.default
              inputs.peerix.nixosModules.peerix
              inputs.disko.nixosModules.disko

              ./hosts/${host}/config.nix
              ({
                config,
                pkgs,
                ...
              }: {
                nixpkgs.overlays = overlays;
                nixpkgs.config.allowUnfree = true;
                nix.settings = {
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  trusted-substituters = ["https://cache.nixos.org/" "https://devenv.cachix.org" "https://cachix.cachix.org" "https://niri.cachix.org" "https://cache.garnix.io"];
                  trusted-public-keys = [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    "devenv.cachix.org-1:psrHoP9TvUKh6bV3+T5SVjHlT/RHb+NxlIye3E7itnk="
                    "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
                    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
                    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                  ];
                };
              })

              home-manager.nixosModules.home-manager
              ({config, ...}: {
                home-manager.extraSpecialArgs = {
                  inherit username inputs host flakeDir hostDir wallpaper pkgs-unstable;
                  variables = import ./hosts/${host}/home/variables.nix;
                  stylixBase16 = config.stylix.base16Scheme;
                };
                home-manager.useGlobalPkgs = true;
                # nixpkgs = {
                #   config = {
                #     allowUnfree = true;
                #     allowUnfreePredicate = _: true;
                #   };
                # };
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.users.${username} = import ./hosts/${host}/home/home.nix;
              })
            ];
        }
    );
  };
}
