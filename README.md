# nix-conf

my nix config

## system update

- `nix flake update`
- `home-manager switch --flake ".user@host"` (eg. `".patrick@p14s"`)
- `sudo nixos-rebuild switch --flake ".host"` (eg. `".p14s"`)

## clean up

- `sudo nix-collect-garbage --delete-older-than 'Yd'` clean up generations (and nix-store) older than Y days
    - rebuild system afterwards to update grub menu
