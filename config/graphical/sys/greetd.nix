{
  username,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.tuigreet];
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
      };
    };
  };
}
