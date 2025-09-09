{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "TychoDesk";
  gitEmail = "tychology@gmail.com";

  # Hyprland Settings
  extraMonitorSettings = ''

    monitor=HDMI-A-1,preferred,0x0,1
    monitor=DP-1, preferred, -1920x0, 1
    monitor=DP-2, preferred, 0x-1080, 1

  '';

  extraInputSettings = ''
  '';

  # Waybar Settings
  clock24h = true;

  # Program Options
  browser = "zen"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  shell = "fish";
}
