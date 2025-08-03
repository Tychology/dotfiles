{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = builtins.fromJSON ''{"base00":"011d45","base01":"184684","base02":"805aa3","base03":"8fa0b0","base04":"c2b6ba","base05":"ffc5a7","base06":"f3d9c2","base07":"f7cfcd","base08":"b57cb1","base09":"4698d0","base0A":"7995a1","base0B":"8c918d","base0C":"9788c1","base0D":"9f8a9d","base0E":"c57e84","base0F":"dd6b9e"}'';
    opacity.terminal = 0.8;

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        # package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
