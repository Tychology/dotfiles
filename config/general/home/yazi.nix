{pkgs, ...}: {

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      sudo = sudo;
      starship = starship;
      git = git;
      chmod = chmod;
      diff = diff;
    } // {
      system-clipboard = ./yazi_plugins/system-clipboard;
      folder-rules = ./yazi_plugins/folder-rules;
      # ouch-yazi = ./yazi_plugins/ouch.yazi;
    };


    settings = {
      mgr = {
        prepend_keymap = [
          {
            on = "<S-y>";
            run = ["plugin system-clipboard"];
          }
        ];
      };
      # open = {
      #   rules = [
      #     {mime = "text/*" use = "edit"};
      #   ];
      # }
    };
  };
}
