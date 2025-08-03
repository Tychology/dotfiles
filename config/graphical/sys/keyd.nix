{...}: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "esc";
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
