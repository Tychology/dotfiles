{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
    pihole-flake.url = "github:mindsbackyard/pihole-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
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
    wallpaper = "cosmiccliffs.jpg";
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs ["think" "desk" "wyse"] (
      host: let
        hostDir = flakeDir + "/hosts/" + host;
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit system inputs username host flakeDir hostDir wallpaper;
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./hosts/${host}/config.nix
            ({
              config,
              pkgs,
              ...
            }: {
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
