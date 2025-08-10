{
  host,
  username,
  ...
}: {
  y = "yy";
  x = "hx";
  cd = "z";
  g = "gitui";
  gl = "git pull";
  gs = "git push";
  ga = "git add *";

  sv = "sudo nvim";
  fr = "nh os switch --hostname ${host} /home/${username}/zaneyos";
  fu = "nh os switch --hostname ${host} --update /home/${username}/zaneyos";
  ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
  v = "nvim";
  cat = "bat";
  ls = "eza --icons";
  ll = "eza -lh --icons --grid --group-directories-first";
  la = "eza -lah --icons --grid --group-directories-first";
  ".." = "cd ..";
  "cd.." = "cd ..";
}
