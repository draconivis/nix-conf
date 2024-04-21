{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./keyboard.nix
    ./locale.nix
    ./nixos.nix
    ./packages.nix
    ./pipewire.nix
    ./systemd-boot.nix
  ];

  programs.zsh.enable = true;
}
