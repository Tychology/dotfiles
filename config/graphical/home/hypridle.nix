{...}: {
  services = {
    hypridle = {
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
