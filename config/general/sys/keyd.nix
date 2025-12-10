{...}: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          global = {
            oneshot_timeout = 500;
          };
          main = {
            shift = "oneshot(shift)";
            meta = "oneshot(meta)";
            control = "oneshot(control)";

            leftalt = "oneshot(alt)";
            rightalt = "oneshot(altgr)";

            capslock = "overload(control, esc)";
            esc = "capslock";
          };
        };
      };
      piantor = {
        ids = ["beeb:0002"];
        settings = {
        };
      };
    };
  };
}
