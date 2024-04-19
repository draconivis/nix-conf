{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  imports = [
    ../common/packages.nix
    # ./global
    # ./features/desktop/hyprland
    # ./features/desktop/wireless
    # ./features/productivity
    # ./features/pass
    # ./features/games
  ];

  home.packages = with pkgs; [
    awscli2
    devbox
    direnv
    docker
    docker-compose
    du-dust
    firefox-devedition-bin
    jetbrains.phpstorm
    lazygit
    mariadb
    pinentry-rofi
    slack
    tmux
#insomnium-bin
  ];
}
