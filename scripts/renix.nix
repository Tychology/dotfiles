{
  pkgs,
  flakeDir,
  ...
}:
pkgs.writeScriptBin "renix" ''
  #!/usr/bin/env bash
  exec 2>&1
  set -e

  pushd ~/dotfiles

  # Check for force argument
  force=false
  if [[ "$1" == "f" ]]; then
      echo "Force rebuild mode enabled — skipping change detection."
      force=true
  fi

  # Early return if no changes were detected, unless 'f' was passed
  if ! $force && git diff --quiet '*.nix' '*.sh'; then
      echo "No changes detected, exiting."
      popd
      exit 0
  fi

  git add .

  alejandra . &>/dev/null \
    || ( alejandra . ; echo "formatting failed!" && exit 1)

  git diff -U0 '*.nix'

  echo "NixOS Rebuilding..."
  nh os switch

  current=$(nixos-rebuild list-generations | grep current)

  git commit -am "nixos: $current"
  git push

  popd

  notify-send -e "NixOS Rebuilt OK!"
''
