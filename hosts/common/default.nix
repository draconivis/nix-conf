{
  inputs,
  outputs,
  ...
}: {
  imports = [
      inputs.home-manager.nixosModules.home-manager
      ./awesome.nix
      ./keyboard.nix
      ./locale.nix
      ./pipewire.nix
      ./systemd-boot.nix
      ./zsh.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
