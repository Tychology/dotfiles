{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = [
    pkgs.arduino-cli
    pkgs.arduino-ide
    pkgs.xorg.libxkbfile
  ];

  users.users.${username}.extraGroups = ["dialout"];

  services.udev.extraRules = ''
    KERNEL=="ttyACM0", MODE:="0666"
  '';
}
