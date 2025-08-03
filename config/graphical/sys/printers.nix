{pkgs, ...}: {
  services = {
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
        pkgs.brlaser
        pkgs.brgenml1lpr
        pkgs.brgenml1cupswrapper
        pkgs.gutenprint
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  hardware.printers.ensurePrinters = [
    {
      name = "Brother";
      model = "brother-BrGenML1-cups-en.ppd";
      deviceUri = "socket://fritz.box:9100"; # Replace with your printer's URI
    }
  ];

  #scanners
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
    disabledDefaultBackends = ["escl"];
  };
}
